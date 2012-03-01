require 'sinatra'


get '/' do
  #this will be replaced with a cloudfront-hosted page.
  erb :search_form
end

get '/search' do
  redirect to('/') unless params.has_key?("Query") 
end
