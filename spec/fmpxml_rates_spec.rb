require 'spec_helper'

describe 'FMPXML rates' do

  before { visit '/rates.fmpxml' }

  describe "contents" do

    it "has an XML declaration" do
      expect(page.body).to include('<?xml version=')
    end

    describe "FMPXMLRESULT" do

      it "has an FMPXMLRESULT tag" do
        expect(page.body).to include('<FMPXMLRESULT')
      end

      it "has the correct namespace" do
        expect(page.body).to include('xmlns="http://www.filemaker.com/fmpxmlresult"')
      end
    end

    describe "ERRORCODE" do

      it "has a 0 errorcode" do
        expect(page.body).to include('<ERRORCODE>0</ERRORCODE>')
      end
    end

    describe "PRODUCT" do

      it "has a product tag" do
        expect(page.body).to include('<PRODUCT')
      end

      it "has a product build" do
        expect(page.body).to include('BUILD="')
      end

      it "has a name of product" do
        expect(page.body).to include('NAME="FileMaker"')
      end

      it "has a version of product" do
        expect(page.body).to include('VERSION="')
      end
    end

    describe "DATABASE" do

      it "has a database tag" do
        expect(page.body).to include('<DATABASE')
      end

      it "has a database date format" do
        expect(page.body).to include('DATEFORMAT="D/m/yyyy"')
      end

      it "has a database layout" do
        expect(page.body).to include('LAYOUT=""')
      end

      it "has a database name" do
        expect(page.body).to include('NAME="Granta.fmp12"')
      end

      it "has a database records" do
        expect(page.body).to include('RECORDS="1"')
      end

      it "has a database time format" do
        expect(page.body).to include('TIMEFORMAT="h:mm:ss a"')
      end
    end

    describe "METADATA" do

      it "has a metadata tag" do
        expect(page.body).to include('<METADATA>')
      end

      it "has a field for ISO 4217 code with text type" do
        expect(page.body).to include('<FIELD EMPTYOK="YES" MAXREPEAT="1" NAME="ISO 4217 Code" TYPE="TEXT"/>')
      end

      it "has a field for bank buying rate with number type" do
        expect(page.body).to include('<FIELD EMPTYOK="YES" MAXREPEAT="1" NAME="Rate Bank Buying" TYPE="NUMBER"/>')
      end

      it "has a field for bank selling rate with number type" do
        expect(page.body).to include('<FIELD EMPTYOK="YES" MAXREPEAT="1" NAME="Rate Bank Selling" TYPE="NUMBER"/>')
      end

      it "has a field for rate updated with timestamp type" do
        expect(page.body).to include('<FIELD EMPTYOK="YES" MAXREPEAT="1" NAME="Rate Updated TimeStamp" TYPE="TIMESTAMP"/>')
      end
    end

    describe "RESULTSET" do

      it "has the correct number of results" do
        expect(page.body).to include('<RESULTSET FOUND="17">')
      end
    end

    describe "exchange rates" do

      it "has an exchange rate to United States dollars" do
        expect(page.body).to include('<DATA>USD</DATA>')
      end

      it "has an exchange rate to Australian dollars" do
        expect(page.body).to include('<DATA>AUD</DATA>')
      end

      it "has an exchange rate to Canadian dollars" do
        expect(page.body).to include('<DATA>CAD</DATA>')
      end

      it "has an exchange rate to Chinese yuan" do
        expect(page.body).to include('<DATA>CNH</DATA>')
      end

      it "has an exchange rate to Danish kroner" do
        expect(page.body).to include('<DATA>DKK</DATA>')
      end

      it "has an exchange rate to Euros" do
        expect(page.body).to include('<DATA>EUR</DATA>')
      end

      it "has an exchange rate to Hong Kong dollars" do
        expect(page.body).to include('<DATA>HKD</DATA>')
      end

      it "has an exchange rate to Indian rupee" do
        expect(page.body).to include('<DATA>INR</DATA>')
      end

      it "has an exchange rate to Indonesian rupiah" do
        expect(page.body).to include('<DATA>IDR</DATA>')
      end

      it "has an exchange rate to Japanese yen" do
        expect(page.body).to include('<DATA>JPY</DATA>')
      end

      it "has an exchange rate to New Zealand dollars" do
        expect(page.body).to include('<DATA>NZD</DATA>')
      end

      it "has an exchange rate to Norwegian kroner" do
        expect(page.body).to include('<DATA>NOK</DATA>')
      end

      it "has an exchange rate to Sri Lankan rupee" do
        expect(page.body).to include('<DATA>LKR</DATA>')
      end

      it "has an exchange rate to British pounds" do
        expect(page.body).to include('<DATA>GBP</DATA>')
      end

      it "has an exchange rate to Swedish krona" do
        expect(page.body).to include('<DATA>SEK</DATA>')
      end

      it "has an exchange rate to Swiss francs" do
        expect(page.body).to include('<DATA>CHF</DATA>')
      end

      it "has an exchange rate to Thai baht" do
        expect(page.body).to include('<DATA>THB</DATA>')
      end
    end
  end
end
