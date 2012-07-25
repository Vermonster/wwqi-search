require 'spec_helper'

describe 'neo4j search page' do

  before do
    HTTParty.delete("http://localhost:7475/db/data/cleandb/xyzzy") # see readme if you don't know what this means 
    @neo = Neo4jWalker.neo
  end

  before(:each) { Neo4jWalker.clear_node_cache! }

  after do
    HTTParty.delete("http://localhost:7475/db/data/cleandb/xyzzy")
  end

  # specs pending design

end
