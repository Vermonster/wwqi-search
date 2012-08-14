require 'spec_helper'

describe 'neo4j_walker' do

  before do
    HTTParty.delete("http://localhost:7475/db/data/cleandb/xyzzy") # see readme if you don't know what this means 
    @neo = Neo4jWalker.neo
  end

  before(:each) { Neo4jWalker.clear_node_cache! }

  after do
    HTTParty.delete("http://localhost:7475/db/data/cleandb/xyzzy")
  end
  
  #it 'debugs' do 
    #binding.pry
  #end

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
        @neo.get_node_properties(paths[0]['nodes'][0])['name'].should == 'A'
        @neo.get_node_properties(paths[0]['nodes'][1])['name'].should == 'D'
        @neo.get_node_properties(paths[1]['nodes'][0])['name'].should == 'A'
        @neo.get_node_properties(paths[1]['nodes'][1])['name'].should == 'B'
        @neo.get_node_properties(paths[1]['nodes'][2])['name'].should == 'D'
        @neo.get_node_properties(paths[2]['nodes'][0])['name'].should == 'A'
        @neo.get_node_properties(paths[2]['nodes'][1])['name'].should == 'C'
        @neo.get_node_properties(paths[2]['nodes'][2])['name'].should == 'E'
        @neo.get_node_properties(paths[2]['nodes'][3])['name'].should == 'D'

        short_paths = Neo4jWalker.paths_between(a, d, :max_length => 2)
        short_paths.size.should == 2
        @neo.get_node_properties(short_paths[0]['nodes'][0])['name'].should == 'A'
        @neo.get_node_properties(short_paths[0]['nodes'][1])['name'].should == 'D'
        @neo.get_node_properties(short_paths[1]['nodes'][0])['name'].should == 'A'
        @neo.get_node_properties(short_paths[1]['nodes'][1])['name'].should == 'B'
        @neo.get_node_properties(short_paths[1]['nodes'][2])['name'].should == 'D'
        
        shortest_paths = Neo4jWalker.paths_between(a, d, :max_length => 1)
        shortest_paths.size.should == 1
        @neo.get_node_properties(shortest_paths[0]['nodes'][0])['name'].should == 'A'
        @neo.get_node_properties(shortest_paths[0]['nodes'][1])['name'].should == 'D'
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

  context '#all_nodes' do
    context 'when nodes exist' do
      it 'should return all the nodes' do
        HTTParty.delete("http://localhost:7475/db/data/cleandb/xyzzy")
        a = @neo.create_node('name' => 'A')
        b = @neo.create_node('name' => 'B')
        c = @neo.create_node('name' => 'C')
        all = Neo4jWalker.all_nodes
        all.size.should == 4
        all.map{|n| n['data']['name']}.compact.sort.should == %w(A B C)
      end
    end

    context 'when none exist' do
      it 'should return just the root node' do
        HTTParty.delete("http://localhost:7475/db/data/cleandb/xyzzy")
        all = Neo4jWalker.all_nodes
        all.size.should == 1
        Neo4jWalker.id_of(all.first).should == "0"
      end
    end
  end

  context '#calculate_and_cache_centrality!' do
    it 'should count the incoming/outgoing connections on each node and store it' do
      a = @neo.create_node('name' => 'A')
      b = @neo.create_node('name' => 'B')
      c = @neo.create_node('name' => 'C')
      d = @neo.create_node('name' => 'D')
      e = @neo.create_node('name' => 'E')
      @neo.create_relationship("related_to", a, b) 
      @neo.create_relationship("related_to", a, d) 
      @neo.create_relationship("related_to", b, d) 
      @neo.create_relationship("related_to", d, c) 
      # A --- B
      #  `.  /
      #    `D
      #    /    
      #   C    E   

      [a, b, c, d, e].each do |n|
        @neo.get_node_properties(n)['centrality'].should be_nil
      end

      Neo4jWalker.calculate_and_cache_centrality!
      @neo.get_node_properties(a)['centrality'].should == 2
      @neo.get_node_properties(b)['centrality'].should == 2
      @neo.get_node_properties(c)['centrality'].should == 1
      @neo.get_node_properties(d)['centrality'].should == 3
      @neo.get_node_properties(e)['centrality'].should == 0
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
        Neo4jWalker.calculate_and_cache_centrality!
        @a = a
        # A -- C
        # |`.  |
        # |  `.|
        # D -- B
      end

      it 'should return closely related nodes' do
        Neo4jWalker.nodes_near(@a).size.should == 3
      end

      it 'should return the most closely related node first' do
        top_result = Neo4jWalker.nodes_near(@a).first
        @neo.get_node_properties(top_result)['name'].should == 'B'
      end

      it 'should find equal relatedness for perfectly symmetrical nodes' do
        nrs = Neo4jWalker.nodes_with_relevances_near(@a) 
        c_result = nrs.select{|nr| @neo.get_node_properties(nr[0])['name'] == 'C'}
        d_result = nrs.select{|nr| @neo.get_node_properties(nr[0])['name'] == 'D'}
        c_result[1].should == d_result[1]
      end
    end

    context 'in more advanced use cases' do
      before do
        a = @neo.create_node('name' => 'A')
        b = @neo.create_node('name' => 'B')
        c = @neo.create_node('name' => 'C')
        d = @neo.create_node('name' => 'D')
        e = @neo.create_node('name' => 'E')
        f = @neo.create_node('name' => 'F')
        g = @neo.create_node('name' => 'G')
        @neo.create_relationship("related_to", a, b) 
        @neo.create_relationship("related_to", a, f) 
        @neo.create_relationship("related_to", b, c) 
        @neo.create_relationship("related_to", b, d) 
        @neo.create_relationship("related_to", b, e) 
        @neo.create_relationship("related_to", f, g) 
        Neo4jWalker.calculate_and_cache_centrality!
        @a = a
        #  A -- F -- G
        #   `.  
        #     `B -- C
        #     / `.   
        #    D    E   
      end

      it 'should rank lower-centrality nodes higher than otherwise identical high-centrality nodes' do
        named_results = Neo4jWalker.nodes_near(@a).map{|r| @neo.get_node_properties(r)['name']}
        named_results.index('F').should < named_results.index('B')
      end

      it 'should rank nodes higher if accessed through low-centrality paths' do
        named_results = Neo4jWalker.nodes_near(@a).map{|r| @neo.get_node_properties(r)['name']}
        named_results.index('G').should < named_results.index('C')
        named_results.index('G').should < named_results.index('D')
        named_results.index('G').should < named_results.index('E')
      end
    end
  end

  context 'gremlin methods' do
    before do
      'a'.upto('k').each do |char| 
        eval "@#{char} = @neo.create_node('name' => '#{char.upcase}')" # :)
      end
      {@a => [@b,@d,@c,@g], @b => [@d,@e,@i], @d => [@i,@k,@h], @c => [@f], @i => [@k], @h => [@j]}.each do |key, vals|
        vals.each do |val|
          @neo.create_relationship('related_to', key, val)
          @neo.create_relationship('related_to', val, key)
        end
      end
      Neo4jWalker.calculate_and_cache_centrality!
      #    .I --- K 
      #  .`  `. .`
      # B ---- D -- H -- J
      # |`.  .`
      # |  `A -- C 
      # E   |    |
      #     G    F
      #
      # from A, expect: G(1) C(2) F(3) B(4) D(5) E(5) H(7) I(7) K(7) J(8) 
    end

    context '#gremlin_nodes_near' do
      it 'should find nodes in the correct order from A' do
        results = Neo4jWalker.gremlin_nodes_near(@a)
        @neo.get_node_properties(results[0])['name'].should == 'G'
        @neo.get_node_properties(results[1])['name'].should == 'C'
        @neo.get_node_properties(results[2])['name'].should == 'F'
        @neo.get_node_properties(results[3])['name'].should == 'B'
        @neo.get_node_properties(results[4])['name'].should == 'D'
        @neo.get_node_properties(results[5])['name'].should == 'E'
        ['H', 'I', 'K'].should include @neo.get_node_properties(results[6])['name']
        ['H', 'I', 'K'].should include @neo.get_node_properties(results[7])['name']
        ['H', 'I', 'K'].should include @neo.get_node_properties(results[8])['name']
        @neo.get_node_properties(results[9])['name'].should == 'J'
      end

      it 'should find nodes in the correct order from F' do
        results = Neo4jWalker.gremlin_nodes_near(@f)
        @neo.get_node_properties(results[0])['name'].should == 'C'
        @neo.get_node_properties(results[1])['name'].should == 'A'
        @neo.get_node_properties(results[2])['name'].should == 'G'
        @neo.get_node_properties(results[3])['name'].should == 'B'
        @neo.get_node_properties(results[4])['name'].should == 'D'
        @neo.get_node_properties(results[5])['name'].should == 'E'
        ['H', 'I', 'K'].should include @neo.get_node_properties(results[6])['name']
        ['H', 'I', 'K'].should include @neo.get_node_properties(results[7])['name']
        ['H', 'I', 'K'].should include @neo.get_node_properties(results[8])['name']
        @neo.get_node_properties(results[9])['name'].should == 'J'
      end
    end

    #context '#gremlin_nodes_relevant_to' do
      ##    .I --- K 
      ##  .`  `. .`
      ## B ---- D -- H -- J
      ## |`.  .`
      ## |  `A -- C 
      ## E   |    |
      ##     G    F
      #it 'should find the nodes most relevant to A' do
        #results = Neo4jWalker.gremlin_nodes_relevant_to(@a)
        #@neo.get_node_properties(results[0])['name'].should == 'G'
        #@neo.get_node_properties(results[1])['name'].should == 'C'
        #@neo.get_node_properties(results[2])['name'].should == 'D'
        #@neo.get_node_properties(results[3])['name'].should == 'B'
        #@neo.get_node_properties(results[4])['name'].should == 'I'
        #@neo.get_node_properties(results[5])['name'].should == 'K'
        #@neo.get_node_properties(results[6])['name'].should == 'F'
        #@neo.get_node_properties(results[7])['name'].should == 'H'
        #@neo.get_node_properties(results[8])['name'].should == 'E'
        #@neo.get_node_properties(results[9])['name'].should == 'J'
      #end

      #it 'should find the nodes most relevant to F' do
        #results = Neo4jWalker.gremlin_nodes_relevant_to(@f)
        #puts results.map{|r| [@neo.get_node_properties(r)['name'], @neo.get_node_properties(r)['path_score']]}
      #end

    #end
  end

  context '#genealogy_of'

end
