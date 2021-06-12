source "https://rubygems.org"
ruby '2.6.7'

gem 'activesupport'
gem 'sinatra'
gem 'rake'
gem 'thin'
gem 'sass'
gem 'foreman'
gem 'enviable'
gem 'kramdown'
gem 'tire', :git => "https://github.com/wwqi/tire.git", :ref => "a8bfae0"

group :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'capybara'
  gem 'launchy'
end

group :test, :development do
  gem 'pry', :require => 'pry'
  gem 'rb-readline'
end
