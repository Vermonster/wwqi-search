require 'sinatra'
require 'tire'


get '/' do
  #this will be replaced with a cloudfront-hosted page.
  erb :search_form
end

get '/search' do
  redirect to('/') unless params.has_key?("Query") 
  query_string = params["Query"]

  @results = Tire.search("_all") do
    query do
      string query_string
    end

    size 100
  end.results

  erb :results

end
