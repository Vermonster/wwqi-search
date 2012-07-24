require 'neography'
require 'enviable'

module Neo4jWalker

  # your search feature shouldn't have to stop at red lights.

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

  def self.nodes_near(a, opts={})
    radius = opts[:max_length] || 4
    results = neo.execute_query (<<-CYPHER)
      start a=node(#{id_of(a)}), x=node(*) 
      match p = a-[*..#{radius}]->x 
      return x, extract(xi in nodes(p) : xi.centrality);
    CYPHER
    # finds paths from a --> other nodes
    # returns array of [X, [centralities of each node in path from A to X]]

    nodes_with_relevances = []

    results['data'].group_by{|r| r[0]}.each do |node, results_for_node|
      relevance = 0.0
      results_for_node.map(&:last).each do |path_centralities|
        path_score = 1.0 / path_centralities.inject(0){|sum, centrality| sum + centrality}
        relevance += path_score
      end
      relevance = relevance / node['data']['centrality']
      nodes_with_relevances << [node, relevance]
    end

    print "\n\n"
    print nodes_with_relevances.map{|n| [n[0]['data']['name'], n[1]]}
    print "\n\n"

    nodes_with_relevances.sort{|a, b| b[1] <=> a[1]}.map(&:first)
  end

  def self.genealogy_of(p)
    raise
  end

end
