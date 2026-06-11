ENV['RACK_ENV'] = 'test'

require_relative '../singdollar_server'
require 'rspec'
require 'capybara/rspec'
require 'json'

Capybara.app = SingdollarServer

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include Capybara::DSL

  conf.before do
    SingdollarServer.reset_exchange_rates_cache!

    allow_any_instance_of(SingDollar::Fetcher)
      .to receive(:fetch_exchange_rates_json)
      .and_return(test_exchange_rates_json)
  end
end

def test_exchange_rates_json
  JSON.generate(
    'lastUpdated' => '2026-06-10T07:00:12+08:00',
    'fxRatesSgd' => test_currency_codes.each_with_index.map do |currency, index|
      {
        'baseCurrencyCode' => currency.to_s.upcase,
        'unitForSGDExchange' => 1,
        'tieredExchangeRates' => [
          {
            'tierLevel' => 1,
            'bankBuyRate' => (1.10 + (index / 100.0)).round(4),
            'bankSellRate' => (1.20 + (index / 100.0)).round(4)
          }
        ]
      }
    end
  )
end

def test_currency_codes
  %i[
    usd aud cad cnh dkk eur hkd inr idr jpy nzd nok lkr gbp sek chf thb
  ]
end
