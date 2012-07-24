require 'neography'
require 'enviable'

module Neo4jWalker

  # because your search is too cool to wait for red lights.

  def self.neo
    @neo ||= Neography::Rest.new(case Environment.app_env.downcase
                                  when 'development'
                                    "http://localhost:7474"
                                  when 'test'
                                    "http://localhost:7475"
                                  else
                                    Environment.neo4j_url || "http://localhost:7474"
                                  end)
  end

  def self.all_nodes
    neo.execute_query("start n=node(*) return n")['data'].map(&:first)
  end

  def self.id_of(n)
    URI.parse(n["self"]).path.split("/").last
  end

  def self.paths_between(a, b, opts={})
    max_length = opts[:max_length] || 5
    result = neo.execute_query (<<-CYPHER)
      start a=node(#{id_of(a)}), b=node(#{id_of(b)}) 
      match p = a-[*..#{max_length}]->b
      return p
    CYPHER
    result['data'].map(&:first)
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
    radius = opts[:max_length] || 4
    results = neo.execute_query (<<-CYPHER)
      start a=node(#{id_of(a)}), x=node(*) 
      match p = a-[*..#{radius}]->x 
      return x, extract(xi in nodes(p) : xi.centrality);
    CYPHER
    nodes_with_relevances = []
    results['data'].group_by{|r| r[0]}.each do |node, results_for_node|
      relevance = 0.0
      results_for_node.map(&:last).each do |path_centralities|
        path_score = 1.0 / path_centralities.inject(0){|sum, centrality| sum + centrality }
        relevance += path_score
      end
      relevance = relevance / node['data']['centrality']
      nodes_with_relevances << [node, relevance]
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
