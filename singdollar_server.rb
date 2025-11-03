require 'sinatra/base'
require 'singdollar'

class SingdollarServer < Sinatra::Base

  configure :development do
    require 'sinatra/reloader'
  end

  configure :production do
    set :host_authorization, { permitted_hosts: [] }
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

  not_found do
    status 404
    erb :not_found
  end

  def rates_xml
    content_type :xml
    SingDollar.exchange_rates.to_xml
  end

  def rates_fmpxml
    content_type :xml
    SingDollar.exchange_rates.to_fmpxml
  end

  get "/health" do
    content_type "text/plain"
    "ok"
  end
end
