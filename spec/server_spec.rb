require 'spec_helper'

describe 'Singdollar Server' do

  describe 'home page' do

    before { visit '/' }

    it "has placeholder text" do
      expect(page.body).to include('Singdollar Server')
    end
  end
end
