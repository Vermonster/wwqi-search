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
#Environment.user_platform_url ||= 'http://localhost:3000' # URL for the user platform links
SEARCH_BASE_URL = "http://#{URI.parse(Environment.search_url).host}"
ELASTICSEARCH_URL = Environment.searchbox_url
ELASTICSEARCH_INDEX = Environment.searchbox_index
Tire.configure do 
  url               ELASTICSEARCH_URL
  global_index_name ELASTICSEARCH_INDEX
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
  true
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

  query = Tire.search(ELASTICSEARCH_INDEX) do
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
  @results = results
  @facets = results.facets
  #set up environment for the template to render
  @lang = lang
  @query = query_string

  erb :results
end

get '/' do
  redirect Environment.main_site_url, 301
end

if ENV['FAKE_PAGES']
  %w(item collection collection_manifest person person_manifest).each do |page|
    get "/:lang/#{page}.html" do |lang|
      @lang = lang.to_sym
      case page
      when 'person'
        @lang == :en ? load_example_person! : load_example_person_farsi!
      end
      erb page.to_sym
    end
  end
end
