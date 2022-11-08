require 'sinatra/base'
require 'singdollar'

class SingdollarServer < Sinatra::Base

  configure :development do
    require 'sinatra/reloader'
  end

  get '/' do
    erb :index
  end

  get '/rates.fmpxml' do
    rates_fmpxml
  end

  get '/rates.xml' do
    rates_xml
  end

  def rates_xml
    content_type :xml
    SingDollar.exchange_rates.to_xml
  end

  def rates_fmpxml
    content_type :xml
    SingDollar.exchange_rates.to_fmpxml
  end
end
