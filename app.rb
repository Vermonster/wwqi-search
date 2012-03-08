require 'sinatra'
require 'tire'
require 'pry'


#def html(path)
  #send_file File.join("views", "#{path}.html")
#end

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
  lang = (params[:lang] || :en).to_sym
  filter_term = params[:filter]

  @results = Tire.search("_all") do
    query do
      string query_string
    end

    facet 'subjects' do
      terms "subjects_#{lang}"
    end

    facet 'genres' do
      terms "genres_#{lang}"
    end

    facet 'type' do
      terms :type
    end

    size 100
  end

  #set up environment for the template to render
  @lang = lang
  @filter_term = filter_term
  @results = @results ? @results.results : [] # because Tire returns nil if the search has no results...

  erb :results

end

get '/stylesheets/main.css' do
  scss :main
end

