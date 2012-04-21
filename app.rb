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


ENV["MAIN_SITE_URL"] ||= 'http://localhost:4567'
ENV["ASSET_URL"] ||= 'http://assets.wwqidev.com'
ENV["SEARCH_URL"] ||= 'http://localhost:4567/search'

SEARCH_BASE_URL = "http://#{URI.parse(ENV["SEARCH_URL"]).host}"

ROOT_INDEX = URI.parse(ENV['BONSAI_INDEX_URL']).path[1..-1]
Tire.configure do 
  url               'http://index.bonsai.io'
  global_index_name ROOT_INDEX
end

def period(i)
  OpenStruct.new(title_en: "Period #{i}",
                 title_fa: "Period_farsi #{i}",
                 end_at: "1900-01-01",
                 start_at: "1800-01-01")
end

Period = [period(1), period(2), period(3), period(4)]

class Array
  def all
    self
  end
end


class Filter
  def initialize(str)
    @filter = parse_filters(str)
  end

  include Enumerable
  extend Forwardable
  delegate [:keys, :delete, :each, :[], :[]=] => :@filter

  def to_s
    map do |type, value|
      "#{type}:#{CGI.escape(value)}"
    end.join('|')
  end
  alias inspect to_s

  def has_filters? 
    !keys.empty? 
  end

  private
  def parse_filters(str)
    return {} if str.blank?
    str.split('|').each_with_object({}) do |pair, acc| 
      type, value = pair.split(":") 
      acc[type] = CGI::unescape(value)
    end
  end
end

class Loopback
  attr_reader :filters

  def initialize(params)
    params = params.with_indifferent_access
    @query = params["query"]
    @page = params["page"].to_i || 1
    @lang = params["lang"].to_sym
    @filters = Filter.new(params["filter"])
  end

  def self.results_per_page
    10
  end

  def query_field
    return "" unless @query
    "&query=#{@query}" 
  end

  def lang_field
    return "" unless @lang
    "lang=#{@lang}" 
  end

  def filter_field
    return "" unless @filters.has_filters?
    "&filter=#{@filters}" 
  end

  def page_field
    return "" if @page.nil? or @page == 0
    "&page=#{@page}" 
  end

  def date_field
    return "" unless @from and @to
    "&#{@from}TO#{@to}"
  end

  def to_url
    "#{ENV["SEARCH_URL"]}?" + lang_field + query_field + filter_field + page_field + date_field
  end

  def increment_page
    @page += 1
    self
  end

  def decrement_page
    @page -= 1
    self
  end

  def to(date)
    @to = date
    self
  end

  def from(date)
    @from = date
    self
  end

  def prev_page?(total)
    @page + 1 > 1
  end

  def next_page?(total)
    @page + 1 < (1.0 * total / Loopback.results_per_page).ceil 
  end

  def update_filter(type, value)
    @filters[type] = CGI.escape(value)
    self
  end

  def remove_filter(type)
    @filters.delete(type)
    self
  end
end


module Helpers

  def javascript(name)
    %Q|<script type='text/javascript' src='/javascripts/#{name}.js'></script>|
  end

  def lang_link_to(text, link, opts={})
    lang = opts.delete(:lang) 
    url = URI.join(ENV["MAIN_SITE_URL"], "#{lang}/", "#{link}")
    
    attributes = ""
    opts.each { |key,value| attributes << key.to_s << "=\"" << value << "\" "}
    "<a href=\"#{url}\" #{attributes}>#{text}</a>"
  end
  
  def return_link(*_)
    Loopback.new(params).to_url
  end

  def loopback(opts = nil)
    Loopback.new(opts || params)
  end

  def partial(path)
    erb("_#{path}".to_sym)
  end

  def stylesheet(name, opts = {})
    extra = opts.inject("") { |a,(key, value)| a << "#{key}=\"#{value}\" " } if opts.keys.any?
    %Q|<link rel="stylesheet" href="/stylesheets/#{name}.css" #{extra} />|
  end

  def search_url
    ENV["SEARCH_URL"]
  end

  def carousel
    ["1131-1141","1134","1016-1139","1131-1142","1019","1025","911","1021A","907-1023","1014","1018","905-906-1017"]
  end

  def carousel_entry(acc)
    entries = { 
      "1131-1141"    => { lang: @lang, img: "collection_33.jpg", text: "Shirin Dukht Sultani Nuri"                 , acc: "1131-1141"    },
      "1134"         => { lang: @lang, img: "collection_35.jpg", text: "Moezzi Family"                             , acc: "1134"         },
      "1016-1139"    => { lang: @lang, img: "collection_8.jpg" , text: "Bahram Sheikholeslami"                     , acc: "1016-1139"    },
      "1131-1142"    => { lang: @lang, img: "collection_25.jpg", text: "Bahman Bayani Collection"                  , acc: "1131-1142"    },

      "1019"         => { lang: @lang, img: "collection_26.jpg", text: "Nush Afarin Ansari"                        , acc: "1019"         },
      "1025"         => { lang: @lang, img: "collection_21.jpg", text: "The Center for Iranian Jewish Oral History", acc: "1025"         },
      "911"          => { lang: @lang, img: "collection_6.jpg" , text: "Houri Mostofi Moghadam"                    , acc: "911"          },
      "1021A"        => { lang: @lang, img: "collection_28.jpg", text: "Najm al-Saltanah"                          , acc: "1021A"        },
      "907-1023"     => { lang: @lang, img: "collection_2.jpg" , text: "Nusrat Mozaffari"                          , acc: "907-1023"     },
      "1014"         => { lang: @lang, img: "collection_7.jpg" , text: "Najmabadi Papers"                          , acc: "1014"         },
      "1018"         => { lang: @lang, img: "collection_19.jpg", text: "Majlis Library, Museum and Document Center", acc: "1018"         },
      "905-906-1017" => { lang: @lang, img: "collection_12.jpg", text: "Sadiqah Dawlatabadi"                       , acc: "905-906-1017" }
    }
    collection_entry(entries[acc])
  end

  def collection_entry(opts = {})
    raise "must provide img" unless opts.has_key? :img
    raise "must provide acc" unless opts.has_key? :acc
    raise "must provide alt or text options" unless opts.has_key? :alt or opts.has_key? :text

    img_url = "#{ENV["ASSET_URL"]}/collection_thumbs/#{opts[:img]}"

    opts[:text] ||= opts[:alt]  # must provide one or the other
    opts[:alt]  ||= opts[:text]

    %Q|<li><a href="/#{opts[:lang]}/collection/#{opts[:acc]}.html">
        <div class="collection-thumb">
          <img src="#{img_url}" alt="#{opts[:alt]}">
          <span>#{opts[:text]}</span>
          <div class="layer1"></div>
          <div class="layer2"></div>
        </div>
      </a></li>|
  end
end

helpers ViewHelpers
helpers Helpers

get '/' do
  redirect ENV["MAIN_SITE_URL"], 301
end

get '/en/search_form' do
  erb :search_form_en
end

get '/fa/search_form' do
  #this will be replaced with a cloudfront-hosted page.
  erb :search_form_fa
end

get '/en/home' do
  @lang = :en
  erb :home
end

get '/fa/home' do
  @lang = :fa
  erb :home
end

get '/en/browse' do
  @lang = :en
  erb :browse
end

get '/fa/browse' do
  @lang = :fa
  erb :browse
end


def add_facet(name)
  facet name do
    terms name, size: 20
    yield if block_given?
  end
end


get '/search' do
  query_string = params["query"] 
  date = params["date"]
  date_start, date_end = params["date"] && params["date"].split('TO')

  filters  = Filter.new(params["filter"])
  lang = (params["lang"] || :en).to_sym
  page = (params["page"] || 0)

  query = Tire.search(ROOT_INDEX) do
    query do
      boolean do
        must { range :date, { from: date_start, to: date_end, boost: 10.0 } } if date

        if query_string
          should { fuzzy "title_#{lang}".to_sym       , query_string , min_similarity: 0.6 , boost: 2   }
          should { fuzzy "description_#{lang}".to_sym , query_string , min_similarity: 0.4 , boost: 0.5 }
          should { string query_string                , boost: 5 }
        else
          should { string '*' } 
        end

        filters.each do |facet, item|
          must { term facet, item }
        end
      end
    end

    add_facet "subjects_#{lang}"
    add_facet "genres_#{lang}" 
    add_facet "people_#{lang}" 
    add_facet "places_#{lang}" 
    add_facet 'type'
    #add_facet 'has_audio'

    size Loopback.results_per_page
    from(page)
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

  erb :results

end

get '/stylesheets/main.css' do
  scss :main
end

get '/collection/:lang/list' do |lang|
  @lang = lang
  erb :collection_manifest
end

get '/collection/:lang/:id.html' do |lang, id|
  @lang = lang
  @id = id
  erb :collection
end

get '/item/:lang/:id.html' do |lang, id|
  @lang = lang
  @id = id
  erb :item
end

def item_index(lang, type, letter)
  facet_name = "#{type}_#{lang}" 
  query = Tire.search ROOT_INDEX do
    query { string "*" } 
    facet facet_name, :global => true do
      terms facet_name, :size => 100
    end
  end
  @lang = lang
  @type = type
  @content = query.results.facets[facet_name]["terms"].map(&:values).delete_if{|item| !item[0].downcase.starts_with?(letter.downcase) if letter }

  erb :item_index 
end

get '/:lang/genres.html'   do |lang| item_index(lang, :genres, params["letter"])   end
get '/:lang/subjects.html' do |lang| item_index(lang, :subjects, params["letter"]) end
get '/:lang/people.html'   do |lang| item_index(lang, :people, params["letter"])   end
get '/:lang/places.html'   do |lang| item_index(lang, :places, params["letter"])   end
