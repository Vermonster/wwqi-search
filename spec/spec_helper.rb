
require 'sinatra'
require 'rack/test'
require 'capybara'
require 'capybara/dsl'
require 'pry'
require 'enviable'


#require File.join(File.dirname(__FILE__), '..', 'app.rb')
require File.join(File.dirname(__FILE__), '..', 'lib/neo4j_walker.rb')

#setup test environment
set :environment, :test
Environment.app_env = 'test'
set :run, false
set :raise_errors, true
set :logging, false

def app
  Sinatra::Application
end

Capybara.app = Sinatra::Application

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Capybara::DSL
end

#include helpers
Dir[File.join(File.dirname(__FILE__), "helpers", "*.rb")].each { |f| require f }
