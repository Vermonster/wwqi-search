require 'neography'
require 'enviable'

module Neo4jWalker

  # because your search is too cool to wait for red lights.

  def self.neo
    @neo ||= Neography::Rest.new(if Environment.app_env && Environment.app_env.downcase == 'test'
                                   'http://localhost:7475'
                                 else
                                   Environment.neo4j_url
                                 end)
  end

  def self.all_nodes
    @all_nodes ||= neo.execute_query("start n=node(*) return n")['data'].map(&:first)
  end

  def self.clear_node_cache!
    @all_nodes = nil
  end

  def self.id_of(n)
    URI.parse(n["self"]).path.split("/").last
  end

  def self.label_for(n)
    props = neo.get_node_properties(n) 
    result = ''
    result += "#{props['accession_num']} -- " if props['type'] == 'Item'
    result += props['name'] || props['name_en'] || props['title_en'] || id_of(n)
  end

  def self.paths_between(a, b, opts={})
    max_length = opts[:max_length] || 4
    result = neo.execute_query (<<-CYPHER)
      start a=node(#{id_of(a)}), b=node(#{id_of(b)}) 
      match p = a-[*..#{max_length}]->b
      return p
      limit 25
    CYPHER
    result && result['data'].map(&:first)
  end

  def self.shortest_paths_between(a, b, opts={})
    max_length = opts[:max_length] || 10
    result = neo.execute_query (<<-CYPHER)
      start a=node(#{id_of(a)}), b=node(#{id_of(b)}) 
      match p = allShortestPaths( a-[*..#{max_length}]->b )
      return p
      limit 25
    CYPHER
    result && result['data'].map(&:first)
  end

  def self.nodes_near(a, opts={})
    nodes_with_relevances_near(a, opts).map(&:first)
  end

  def self.nodes_with_relevances_near(a, opts={})
    #
    # Cypher:
    #   find all short paths from A --> other nodes X_i
    #   return array of [X_i, [centralities of each node in path from A to X_i]]
    # Ruby:
    #   find relevance of each X_i wrt A,
    #   where relevance of X wrt A is defined to be
    #     1/centrality_of(X) * sum(paths_from_A_to_X){ 1/sum(nodes_in_path){ centrality_of(node) } }
    #
    radius = opts[:max_length] || 2
    results = neo.execute_query (<<-CYPHER)
      start a=node(#{id_of(a)}), x=node(*) 
      match p = a-[*..#{radius}]->x 
      where (x.id? <> a.id)
      return x, extract(xi in nodes(p) : xi.centrality)
      limit 5000
    CYPHER
    nodes_with_relevances = []
    if results
      results['data'].group_by{|r| r[0]}.each do |node, results_for_node|
        relevance = 0.0
        results_for_node.map(&:last).each do |path_centralities|
          path_resistance =  path_centralities.inject(0){|sum, centrality| sum + centrality }
          relevance += 1.0 / path_resistance
        end
        nodes_with_relevances << [node, relevance]
      end
    end
    nodes_with_relevances.sort{|x1, x2| x2[1] <=> x1[1]}
  end

  def self.calculate_and_cache_centrality!
    all_nodes.each do |n|
      incoming = neo.execute_query (<<-CYPHER)
        start n=node(#{id_of(n)}) 
        match (n)--(x) 
        return count(*)
      CYPHER
      neo.set_node_properties(n, {"centrality" => incoming['data'].flatten.first}) 
    end
  end

  def self.genealogy_of(p)
    raise
  end

end
