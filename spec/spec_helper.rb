ENV['RACK_ENV'] = 'test'

require_relative '../singdollar_server'
require 'rspec'
require 'capybara/rspec'
require 'rack/test'

include Rack::Test::Methods

class SingdollarServer
  set :environment, :test
end

def app
  SingdollarServer
end

Capybara.app = SingdollarServer

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include Capybara::DSL
end
