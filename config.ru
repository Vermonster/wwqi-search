require 'rubygems'
require 'sinatra'

set :environment, :production
set :port, 8000

disable :run, :reload

#require 'sass/plugin/rack'
#Sass::Plugin.options[:template_location] = 'public/stylesheets'
#use Sass::Plugin::Rack

require './app'

run Sinatra::Application
