ENV['RACK_ENV'] = 'test'

require_relative '../singdollar_server'
require 'rspec'
require 'capybara/rspec'

Capybara.app = SingdollarServer

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include Capybara::DSL

  conf.before do
    allow(SingDollar).to receive(:exchange_rates).and_return(test_exchange_rates)
  end
end

def test_exchange_rates
  rates = SingDollar::ExchangeRates.new
  rates.date_time = Time.utc(2026, 6, 10, 7, 0, 12)

  %i[
    usd aud cad cnh dkk eur hkd inr idr jpy nzd nok lkr gbp sek chf thb
  ].each_with_index do |currency, index|
    rates[currency] = SingDollar::ExchangeRate.new(
      currency: currency,
      bank_buying: test_transaction(currency, :bank_buying, 1.10 + (index / 100.0)),
      bank_selling: test_transaction(currency, :bank_selling, 1.20 + (index / 100.0))
    )
  end

  rates
end

def test_transaction(currency, type, rate)
  SingDollar::Transaction.new(
    currency: currency,
    type: type,
    rate: rate.round(4)
  )
end
