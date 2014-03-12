ENV['RACK_ENV'] = 'test'

require_relative '../singdollar_server'
require 'rspec'
require 'capybara/rspec'

Capybara.app = SingdollarServer

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include Capybara::DSL
end
