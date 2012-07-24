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
      incoming_nodes = neo.execute_query (<<-CYPHER)
        start n=node(#{id_of(n)}), m=node(*) 
        match p = m-[1]-n 
        return p
      CYPHER
      neo.set_node_properties(n, {"centrality" => incoming_nodes['data'].length}) 
    end
  end

  def self.nodes_near(a, opts={})
    raise
  end

  def self.genealogy_of(p)
    raise
  end

end
