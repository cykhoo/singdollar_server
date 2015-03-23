require 'spec_helper'

describe 'XML rates' do

  before { visit '/rates.xml' }

  describe "contents" do

    it "has an XML declaration" do
      expect(page.body).to include('<?xml version=')
    end

    it "has a singdollar element" do
      expect(page.body).to include('<singdollar>')
    end

    it "has an exchange rates element" do
      expect(page.body).to include('<exchange-rates')
    end

    describe "exchange rates" do

      it "has an exchange rate to United States dollars" do
        expect(page.body).to include('<exchange-rate currency="USD">')
      end

      it "has an exchange rate to Australian dollars" do
        expect(page.body).to include('<exchange-rate currency="AUD">')
      end

      it "has an exchange rate to Canadian dollars" do
        expect(page.body).to include('<exchange-rate currency="CAD">')
      end

      it "has an exchange rate to Chinese yuan" do
        expect(page.body).to include('<exchange-rate currency="CNH">')
      end

      it "has an exchange rate to Danish kroner" do
        expect(page.body).to include('<exchange-rate currency="DKK">')
      end

      it "has an exchange rate to Euros" do
        expect(page.body).to include('<exchange-rate currency="EUR">')
      end

      it "has an exchange rate to Hong Kong dollars" do
        expect(page.body).to include('<exchange-rate currency="HKD">')
      end

      it "has an exchange rate to Indian rupee" do
        expect(page.body).to include('<exchange-rate currency="INR">')
      end

      it "has an exchange rate to Indonesian rupiah" do
        expect(page.body).to include('<exchange-rate currency="IDR">')
      end

      it "has an exchange rate to Japanese yen" do
        expect(page.body).to include('<exchange-rate currency="JPY">')
      end

      it "has an exchange rate to New Zealand dollars" do
        expect(page.body).to include('<exchange-rate currency="NZD">')
      end

      it "has an exchange rate to Norwegian kroner" do
        expect(page.body).to include('<exchange-rate currency="NOK">')
      end

      it "has an exchange rate to Sri Lankan rupee" do
        expect(page.body).to include('<exchange-rate currency="LKR">')
      end

      it "has an exchange rate to British pounds" do
        expect(page.body).to include('<exchange-rate currency="GBP">')
      end

      it "has an exchange rate to Swedish krona" do
        expect(page.body).to include('<exchange-rate currency="SEK">')
      end

      it "has an exchange rate to Swiss francs" do
        expect(page.body).to include('<exchange-rate currency="CHF">')
      end

      it "has an exchange rate to Thai baht" do
        expect(page.body).to include('<exchange-rate currency="THB">')
      end
    end
  end
end
