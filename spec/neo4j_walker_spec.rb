require 'spec_helper'

describe 'neo4j_walker' do

  before do
    HTTParty.delete("http://localhost:7475/db/data/cleandb/xyzzy") # see neo4j-development-readme if you don't know what this means 
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

        paths = Neo4jWalker.paths_between(a, d)
        paths.size.should == 3
        
        short_paths = Neo4jWalker.paths_between(a, d, :max_length => 1)
        short_paths.size.should == 1
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

        Neo4jWalker.paths_between(a, d).should == []
      end
    end
  end

  context '#nodes_near'
  context '#genealogy_of'

end
