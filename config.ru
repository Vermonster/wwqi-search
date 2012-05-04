require 'rubygems'
require 'sinatra'
require 'active_record'

set :environment, :production
set :port, ENV['PORT'] || 8000

use ActiveRecord::ConnectionAdapters::ConnectionManagement

disable(:run, :reload) unless ENV['APP_ENV'] == 'DEVELOPMENT'

require './app'

run Sinatra::Application
