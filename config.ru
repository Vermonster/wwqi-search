require 'bundler/setup'
require 'rubygems'
require 'sinatra'

set :port, ENV['PORT'] || 8000

if ENV['APP_ENV'] == 'DEVELOPMENT'
  set :environment, :development
  enable(:run, :reload)
else
  set :environment, :production
  disable(:run, :reload)
end

require './app'

run Sinatra::Application
