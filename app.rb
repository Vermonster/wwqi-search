#encoding: utf-8
require 'sinatra'
require 'date'
require 'tire'
require 'pry'
require 'sass'
require 'active_support'
require 'active_support/core_ext'
require 'forwardable'
require 'cgi'
require 'enviable'

require './views/view_helpers'
require './initializers/activerecord'
require './lib/translation'


Environment.main_site_url ||= 'http://localhost:5000'
Environment.asset_url ||= 'http://assets.wwqidev.com'
Environment.search_url ||= 'http://localhost:5000/search'
SEARCH_BASE_URL = "http://#{URI.parse(Environment.search_url).host}"
ROOT_INDEX = URI.parse(Environment.bonsai_index_url).path[1..-1]
Tire.configure do 
  url               'http://index.bonsai.io'
  global_index_name ROOT_INDEX
end

require './lib/ext'
require './lib/design_routes'
require './lib/helper'
require './lib/loopback'
require './lib/neo4j_walker'

include DesignRoutes
helpers ViewHelpers
helpers Helpers

def add_facet(name)
  facet name do
    terms name, size: 1000000
    yield if block_given?
  end
end

def on_search_page? 
  $on_search_page #this is terrible.
end

get '/search' do
  query_string = params["query"] 
  query_string += 's' if query_string.try(:downcase) == 'will'
  date = params["date"]
  sorter = params["sort"]
  date_start, date_end = params["date"] && params["date"].split('TO')
  filters  = Filter.new(params["filter"])
  lang = (params["lang"] || :en).to_sym
  
  if params["page"].to_i < 0 || params["page"].nil?
    page = 0
  else
    page = params["page"].to_i
  end

  query = Tire.search(ROOT_INDEX) do
    query do
      boolean do
        must { range :date, { from: date_start, to: date_end, boost: 10.0 } } if date

        if query_string.present?
          if query_string.length > 4
            sim_adj = 1.0 / 2.0**query_string.length
            boost_adj = 1 + 1.0 / 2.0**query_string.length

            should { fuzzy "title_#{lang}".to_sym, 
                     query_string , min_similarity: 0.5 + sim_adj , boost: 2   * boost_adj }

            should { fuzzy "description_#{lang}".to_sym,
                     query_string , min_similarity: 0.4 + sim_adj , boost: 0.5 * boost_adj }
          end

          must { string query_string , boost: 15 }
          should { string "#{query_string}*" , boost: 1 } 
        else 
          should { string "*" } 
        end

        filters.each do |facet, item|
          must { term facet, item }
        end

      end
    end

    sort { by "sortable_#{sorter}_#{lang}" } if sorter
    
    add_facet "genres_#{lang}" 
    add_facet "subjects_#{lang}"
    add_facet "collections_#{lang}" 
    add_facet "people_#{lang}" 
    add_facet "places_#{lang}" 
    add_facet "translation"
    add_facet "transcription"

    size Loopback.results_per_page
    from(page * Loopback.results_per_page)
  end

  # paging -- only display some of the results
  results = (query && query.results) || []
  @total_results = results.total
  @total_pages = (1.0 * results.total / Loopback.results_per_page).ceil
  @results = results
  @facets = results.facets
  #set up environment for the template to render
  @lang = lang
  @query = query_string

  $deliberate_hack = false
  $on_search_page = true

  erb :results
end

def item_index(lang, type, letter)
  facet_name = "#{type}_#{lang}" 
  query = Tire.search ROOT_INDEX do
    query { string "*" } 
    facet facet_name, :global => true do
      terms facet_name, :size => 100000
    end
  end
  @lang = lang.to_sym
  @type = type
  @content = query.results.facets[facet_name]["terms"].map(&:values).delete_if{|item| !item[0].downcase.starts_with?(letter.downcase) if letter }
  
  @object = Class.new do
    def initialize(type)
      @type = type
    end

    def __url(target_lang)
      "/#{target_lang}/#{@type}.html"
    end
  end.new(type)
  
  $deliberate_hack = true
  $on_search_page = false
  erb :item_index 
end

get '/' do
  redirect Environment.main_site_url, 301
end

get '/:lang/genres.html'   do |lang| item_index(lang, :genres,   params["letter"]) end
get '/:lang/subjects.html' do |lang| item_index(lang, :subjects, params["letter"]) end
get '/:lang/people.html'   do |lang| item_index(lang, :people,   params["letter"]) end
get '/:lang/places.html'   do |lang| item_index(lang, :places,   params["letter"]) end


get '/advanced_search' do

  # if there are params, do some ruby
  #
  
  @lang = params['lang']
  # bloody hack

  #@nodes ||= []
  @n_nodes ||= Neo4jWalker.neo.execute_query("start n=node(*) return count(n)")['data'].flatten.first.to_i
  @nodes = 1.upto(@n_nodes-1).map{|i| [i,i]}
    
  #if @nodes.size == 0
    #n_nodes = Neo4jWalker.neo.execute_query("start n=node(*) return count(n)-1")['data'].first.first.to_i
    #1.upto(n_nodes) do |i|
      #node = Neo4jWalker.neo.get_node(i)
      #@nodes << [i, Neo4jWalker.label_for(node)]
    #end
  #end

  #@nodes = Neo4jWalker.all_nodes.map{|n| [Neo4jWalker.id_of(n), Neo4jWalker.label_for(n)]}.reject{|n| n[0].to_s == '0'}
  
  case params['search_type']
  when 'between'
    @source = Neo4jWalker.neo.get_node(params['source'])
    @target = Neo4jWalker.neo.get_node(params['target'])
    @paths = Neo4jWalker.shortest_paths_between(@source, @target, {:max_length => params['max_length']}) if @source && @target
  when 'related'
    @node = Neo4jWalker.neo.get_node(params['node'])
    @related_nodes = Neo4jWalker.nodes_with_relevances_near(@node) if @node
  end

  erb :advanced_search
end



