require 'rubygems'
require 'sinatra'
require 'active_record'

set :port, ENV['PORT'] || 8000

use ActiveRecord::ConnectionAdapters::ConnectionManagement

if ENV['APP_ENV'] == 'DEVELOPMENT'
  set :environment, :development
  enable(:run, :reload)
else
  set :environment, :production
  disable(:run, :reload)
end  

require './app'

run Sinatra::Application
