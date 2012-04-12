require 'sinatra'
require 'date'
require 'tire'
require 'pry'
require 'sass'
require 'active_support'
require 'active_support/core_ext'

require './views/view_helpers'


ENV["MAIN_SITE_URL"] ||= 'http://www.wwqidev.com'


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
end

helpers ViewHelpers
helpers Helpers



get '/' do
  redirect ENV["MAIN_SITE_URL"], 301
end

get '/en/search_form' do
  redirect to('/search_form')
end

get '/fa/search_form' do
  #this will be replaced with a cloudfront-hosted page.
  erb :search_form_fa
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
