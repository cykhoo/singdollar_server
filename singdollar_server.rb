require 'sinatra/base'
require 'singdollar'
require 'memcachier'
require 'dalli'

class SingdollarServer < Sinatra::Base

  configure :development do
    require 'sinatra/reloader'
  end

  configure :production do
    require 'newrelic_rpm'
  end

  set :cache, Dalli::Client.new

  get '/' do
    erb :index
  end

  get '/rates.fmpxml' do
    rates_fmpxml
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

  def rates_fmpxml
    content_type :xml

    settings.cache.fetch("exchange_rates_fmpxml") do
      exchange_rates = SingDollar.create.to_fmpxml
      settings.cache.set("exchange_rates_fmpxml", exchange_rates, 600)
      exchange_rates
    end
  end
end
