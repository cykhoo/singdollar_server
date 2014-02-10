require 'sinatra'
require 'singdollar'
require "sinatra/reloader" if development?
require 'memcachier'
require 'dalli'

set :cache, Dalli::Client.new

get '/' do
  erb :index
end

get '/rates' do
  rates_xml
end

def rates_xml
  content_type :xml

  settings.cache.fetch("exchange_rates") do
    exchange_rates = SingDollar.create.to_xml
    settings.cache.set("exchange_rates", exchange_rates, 600)
    exchange_rates
  end
end
