require 'spec_helper'

describe 'neo4j_walker' do

  before do
    HTTParty.delete("http://localhost:7475/db/data/cleandb/xyzzy") # see readme if you don't know what this means 
    @neo = Neo4jWalker.neo
  end

  context '#paths_between' do
    context 'when paths exist' do
      it 'should return them' do
        a = @neo.create_node('name' => 'A')
        b = @neo.create_node('name' => 'B')
        c = @neo.create_node('name' => 'C')
        d = @neo.create_node('name' => 'D')
        e = @neo.create_node('name' => 'E')
        @neo.create_relationship("related_to", a, b) 
        @neo.create_relationship("related_to", a, c) 
        @neo.create_relationship("related_to", a, d) 
        @neo.create_relationship("related_to", b, d) 
        @neo.create_relationship("related_to", c, e) 
        @neo.create_relationship("related_to", e, d) 
        # A --- B
        # |`.  /
        # |  `D
        # |    `.
        # C ---- E   

        paths = Neo4jWalker.paths_between(a, d)
        paths.size.should == 3

        short_paths = Neo4jWalker.paths_between(a, d, :max_length => 2)
        short_paths.size.should == 2
        
        shortest_paths = Neo4jWalker.paths_between(a, d, :max_length => 1)
        shortest_paths.size.should == 1
      end
    end
    
    context 'when none exist' do
      it 'should return an empty array' do
        a = @neo.create_node('name' => 'A')
        b = @neo.create_node('name' => 'B')
        c = @neo.create_node('name' => 'C')
        d = @neo.create_node('name' => 'D')
        e = @neo.create_node('name' => 'E')
        @neo.create_relationship("related_to", a, b) 
        @neo.create_relationship("related_to", a, c) 
        @neo.create_relationship("related_to", e, d) 
        # A -- B
        # |
        # |    D -- E
        # C

        Neo4jWalker.paths_between(a, d).should == []
      end
    end
  end

  context '#nodes_near' do
    context 'in its basic functionality' do
      before do
        a = @neo.create_node('name' => 'A')
        b = @neo.create_node('name' => 'B')
        c = @neo.create_node('name' => 'C')
        d = @neo.create_node('name' => 'D')
        @neo.create_relationship("related_to", a, b) 
        @neo.create_relationship("related_to", a, c) 
        @neo.create_relationship("related_to", a, d) 
        @neo.create_relationship("related_to", c, b) 
        @neo.create_relationship("related_to", d, b) 
        # A -- C
        # |`.  |
        # |  `.|
        # D -- B
      end

      it 'should return closely related nodes' do
        Neo4jWalker.nodes_near(a).size.should == 3
      end

      it 'should return the most closely related node first' do
        Neo4jWalker.nodes_near(a).first['properties']['name'].should == 'B'
      end

      it 'should find equal relatedness for perfectly symmetrical nodes' do
        r = Neo4jWalker.nodes_near(a) 
        c_result = r.select{|n| n['properties']['name'] == 'C'}
        d_result = r.select{|n| n['properties']['name'] == 'D'}
        c_result['relatedness'].should == d_result['relatedness']
      end
    end
  end

  context '#genealogy_of'

end
