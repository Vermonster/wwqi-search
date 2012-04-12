require 'sinatra'
require 'date'
require 'tire'
require 'pry'
require 'sass'
require 'active_support'
require 'active_support/core_ext'

require './views/view_helpers'


ENV["MAIN_SITE_URL"] ||= 'http://www.wwqidev.com'
ENV["ASSET_URL"] ||= 'http://assets.wwqidev.com'
ENV["SEARCH_URL"] ||= 'http://www.wwqidev.com/search'

ROOT_INDEX = URI.parse(ENV['BONSAI_INDEX_URL']).path[1..-1]
Tire.configure do 
  url               'http://index.bonsai.io'
  global_index_name ROOT_INDEX
end


module Helpers
  def return_link(opts = {})
    query = params.merge(opts)
    request_string = query.map {|k,v| "#{k}=#{v}"}.join('&')
    "/search?#{request_string}"
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

get '/search' do
  redirect to('/') unless params.has_key?("query") 
  query_string = params["query"]
  filter_term  = params[:filter_term]
  lang = (params[:lang]  || :en).to_sym
  page = (params["page"] || 1).to_i
  results_per_page = 10

  query = Tire.search(ROOT_INDEX) do
    query do
      string query_string
    end

    facet "subjects_#{lang}" do
      terms "subjects_#{lang}"
    end

    facet "genres_#{lang}" do
      terms "genres_#{lang}"
    end

    facet 'type' do
      terms :type
    end

    if filter_term 
      filter_items = filter_term.split(":")
      facet_name = filter_items.shift
      filter :terms, { facet_name => filter_items }
    end

    size 100
  end

  # paging -- only display some of the results
  results = (query && query.results) || []
  @total_pages = (1.0*results.length / results_per_page).ceil
  @results = results[(page-1)*results_per_page..page*results_per_page-1] || []

  #set up environment for the template to render
  @lang = lang
  @filter_term = filter_term
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

def item_index(lang, type)
  facet_name = "#{type}_#{lang}" 
  query = Tire.search ROOT_INDEX do
    query { string "*" } 
    facet facet_name do
      terms facet_name
    end
  end
  @lang = lang
  @content = query.results.facets[facet_name]["terms"].map(&:values)

  erb :item_index 
end

get '/:lang/genres'   do |lang| item_index(lang, :genres)   end
get '/:lang/subjects' do |lang| item_index(lang, :subjects) end
get '/:lang/people'   do |lang| item_index(lang, :people)   end
get '/:lang/places'   do |lang| item_index(lang, :places)   end
