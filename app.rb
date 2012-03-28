require 'sinatra'
require 'tire'
require 'pry'
require 'sass'


def return_link(opts = {})
  query = params.merge(opts)
  request_string = query.map {|k,v| "#{k}=#{v}"}.join('&')
  "/search?#{request_string}"
end

get '/' do
  #this will be replaced with a cloudfront-hosted page.
  erb :search_form_en
end

get '/en' do
  redirect to('/')
end

get '/fa' do
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
  
  query = Tire.search("_all") do
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

