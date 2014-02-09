require 'rack/test'
require 'rspec'
require 'capybara/rspec'
require_relative '../app'

ENV['RACK_ENV'] = 'test'

def app
  Sinatra::Application
end

Capybara.app = Sinatra::Application

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include Capybara::DSL
end
