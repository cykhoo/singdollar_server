source "https://rubygems.org"

ruby '3.1.1'

gem 'sinatra'
gem 'puma'
gem 'memcachier'
gem 'dalli'
gem 'webrick'

source 'https://rubygems.pkg.github.com/cykhoo' do
  gem 'singdollar'
end

# use mina for deployment
# gem 'mina'
# gem 'mina-unicorn', require: false

group :development, :test do
  gem 'sinatra-contrib'
  gem 'rspec'
  gem 'capybara'
end
