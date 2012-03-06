require 'sinatra'
require 'tire'


def html(path)
  send_file File.join("views", "#{path}.html")
end

get '/' do
  #this will be replaced with a cloudfront-hosted page.
  html :search_form_en
end

get '/en' do
  redirect to('/')
end

get '/fa' do
  #this will be replaced with a cloudfront-hosted page.
  html :search_form_fa
end

get '/search' do
  redirect to('/') unless params.has_key?("Query") 
  query_string = params["Query"]

  @results = Tire.search("_all") do
    query do
      string query_string
    end

    size 100
  end

  @results = @results ? @results.results : [] # because Tire returns nil if the search has no results...

  erb :results

end
