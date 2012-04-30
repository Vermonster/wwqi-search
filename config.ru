require 'rubygems'
require 'sinatra'
require 'active_record'

set :environment, :production
set :port, 8000

use ActiveRecord::ConnectionAdapters::ConnectionManagement

disable(:run, :reload) if ENV["PRODUCTION"] 

require './app'

run Sinatra::Application
