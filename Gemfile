source "http://rubygems.org"

ruby '2.2.2'

gem 'sinatra'
gem 'unicorn'
gem 'memcachier'
gem 'dalli'
gem 'newrelic_rpm'

gem 'singdollar', git: 'https://privategem:egS-dge-oS4-6ZN@bitbucket.org/cykhoo/singdollar.git'

# use mina for deployment
gem 'mina'
gem 'mina-unicorn', require: false

group :development, :test do
  gem 'sinatra-contrib'
  gem 'rspec'
  gem 'capybara'
end
