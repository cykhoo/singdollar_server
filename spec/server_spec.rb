require 'spec_helper'

describe 'Singdollar Server' do

  describe 'home page' do

    before { visit '/' }

    it "has placeholder text" do
      expect(page.body).to include('Singdollar Server')
    end
  end

  describe 'exchange rates cache' do

    it "reuses one fetched exchange rates object across rate formats" do
      fetch_count = 0

      allow_any_instance_of(SingDollar::Fetcher)
        .to receive(:fetch_exchange_rates_json) do
          fetch_count += 1
          test_exchange_rates_json
        end

      visit '/rates.xml'
      visit '/rates.fmpxml'

      expect(fetch_count).to eq(1)
    end
  end
end
