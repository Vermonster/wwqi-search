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

  def self.paths_between(a, b, opts={})
    max_length = opts[:max_length] || 5
    aid = URI.parse(a["self"]).path.split("/").last
    bid = URI.parse(b["self"]).path.split("/").last

    result = neo.execute_query (<<-CYPHER)
      start a=node(#{aid}), b=node(#{bid}) 
      match p = a-[*..#{max_length}]->b
      return p
    CYPHER

    result['data']
  end

  def self.nodes_near(a)
    raise
  end

  def self.genealogy_of(p)
    raise
  end

end
