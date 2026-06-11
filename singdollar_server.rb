require 'sinatra/base'
require 'singdollar'

class SingdollarServer < Sinatra::Base
  EXCHANGE_RATES_CACHE_TTL = Integer(ENV.fetch('EXCHANGE_RATES_CACHE_TTL', '300'))

  @exchange_rates_cache_mutex = Mutex.new
  @exchange_rates_cache = nil
  @exchange_rates_cache_expires_at = 0.0

  class << self
    def cached_exchange_rates
      now = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      return @exchange_rates_cache if exchange_rates_cache_valid?(now)

      @exchange_rates_cache_mutex.synchronize do
        now = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        return @exchange_rates_cache if exchange_rates_cache_valid?(now)

        @exchange_rates_cache = SingDollar.exchange_rates
        @exchange_rates_cache_expires_at = now + EXCHANGE_RATES_CACHE_TTL
        @exchange_rates_cache
      end
    end

    def reset_exchange_rates_cache!
      @exchange_rates_cache_mutex.synchronize do
        @exchange_rates_cache = nil
        @exchange_rates_cache_expires_at = 0.0
      end
    end

    private

    def exchange_rates_cache_valid?(now)
      @exchange_rates_cache && now < @exchange_rates_cache_expires_at
    end
  end

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
    exchange_rates.to_xml
  end

  def rates_fmpxml
    content_type :xml
    exchange_rates.to_fmpxml
  end

  get "/health" do
    content_type "text/plain"
    "ok"
  end

  def exchange_rates
    self.class.cached_exchange_rates
  end
end
