ENV['RACK_ENV'] = 'test'

require_relative '../singdollar_server'
require 'rspec'
require 'capybara/rspec'

Capybara.app = SingdollarServer

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include Capybara::DSL
end

begin
  SingdollarServer.new.settings.cache.set("foo:bar", "baz", 600)
rescue
  puts
  puts "*******************************************************"
  puts "*                                                     *"
  puts "*      Specs disabled as memcache is not running      *"
  puts "*                                                     *"
  puts "*               memcached -l localhost                *"
  puts "*                                                     *"
  puts "*                         or                          *"
  puts "*                                                     *"
  puts "*           foreman start -f Procfile.local           *"
  puts "*                                                     *"
  puts "*******************************************************"
  puts
  exit
end
