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

require './views/view_helpers'
require './initializers/activerecord'
require './lib/translation'



ENV["MAIN_SITE_URL"] ||= 'http://localhost:4567'
ENV["ASSET_URL"] ||= 'http://assets.wwqidev.com'
ENV["SEARCH_URL"] ||= 'http://localhost:4567/search'
SEARCH_BASE_URL = "http://#{URI.parse(ENV["SEARCH_URL"]).host}"
ROOT_INDEX = URI.parse(ENV['BONSAI_INDEX_URL']).path[1..-1]
Tire.configure do 
  url               'http://index.bonsai.io'
  global_index_name ROOT_INDEX
end

require './lib/ext'
require './lib/design_routes'
require './lib/helper'
require './lib/loopback'

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
  date = params["date"]
  sorter = params["sort"]
  date_start, date_end = params["date"] && params["date"].split('TO')
  filters  = Filter.new(params["filter"])
  lang = (params["lang"] || :en).to_sym
  page = (params["page"] || 0).to_i

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

    add_facet "subjects_#{lang}"
    add_facet "genres_#{lang}" 
    add_facet "people_#{lang}" 
    add_facet "places_#{lang}" 
    add_facet "collections_#{lang}" 
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
  redirect ENV["MAIN_SITE_URL"], 301
end

get '/:lang/genres.html'   do |lang| item_index(lang, :genres,   params["letter"]) end
get '/:lang/subjects.html' do |lang| item_index(lang, :subjects, params["letter"]) end
get '/:lang/people.html'   do |lang| item_index(lang, :people,   params["letter"]) end
get '/:lang/places.html'   do |lang| item_index(lang, :places,   params["letter"]) end



