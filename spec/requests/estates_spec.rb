require 'rails_helper'

RSpec.describe 'Estates', type: :request do
  let(:api) { '/api/v1/' }

  describe 'GET /estates' do
    before(:each) do
      5.times do
        Estate.create!(street:           Faker::Address.street_name,
                       city:             Faker::Address.city,
                       zip:              Faker::Address.zip,
                       state:            Faker::Address.state,
                       beds:             [1, 2, 3].sample,
                       baths:            [1, 2].sample,
                       longitude:        Faker::Address.longitude,
                       latitude:         Faker::Address.latitude,
                       residential_type: ['Residential', 'Condo', 'Multi-Family'].sample,
                       sale_date:        Date.today - 10.days,
                       price:            [59_000.0, 66_000.0, 75_000.0].sample,
                       sq_ft:            [950, 1500, 1250, 754].sample)
      end
      get "#{api}/estates"
    end

    it 'works!' do
      expect(response).to have_http_status(200)
    end

    it 'get details from json respond' do
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eql('Success')
      expect(json_response['data'].count).to eql(Estate.count)
    end
  end

  describe 'GET #Search' do
    before(:each) do
      5.times do
        Estate.create!(street:           Faker::Address.street_name,
                       city:             Faker::Address.city,
                       zip:              Faker::Address.zip,
                       state:            Faker::Address.state,
                       beds:             [1, 2, 3].sample,
                       baths:            [1, 2].sample,
                       longitude:        Faker::Address.longitude,
                       latitude:         Faker::Address.latitude,
                       residential_type: ['Residential', 'Condo', 'Multi-Family'].sample,
                       sale_date:        Date.today - 10.days,
                       price:            [59_000.0, 66_000.0, 75_000.0].sample,
                       sq_ft:            [950, 1500, 1250, 754].sample)
      end
    end

    it 'will retrieve records based on given filters' do
      get "#{api}/estates/search?starting_price=150000"
      search_response = JSON.parse(response.body)
      expect(search_response['data'].count).to eql(0)
    end

    it 'will retrieve records based on given pricing filters' do
      get "#{api}/estates/search?starting_price=45000&&ending_price=100000"
      search_response = JSON.parse(response.body)
      expect(search_response['data'].count).to eql(5)
    end

    it 'will retrieve records based on given type filters' do
      get "#{api}/estates/search?type=unknown"
      search_response = JSON.parse(response.body)
      expect(search_response['data']).to eql([])
    end

    it 'will retrieve records based on given squares filters' do
      get "#{api}/estates/search?starting_square=650&&ending_square=1800"
      search_response = JSON.parse(response.body)
      expect(search_response['data'].count).to eql(5)
    end
  end

  describe '#Show' do
    it 'will show specific real estate details' do
      record = Estate.create!(street:           Faker::Address.street_name,
                              city:             Faker::Address.city,
                              zip:              Faker::Address.zip,
                              state:            Faker::Address.state,
                              beds:             [1, 2, 3].sample,
                              baths:            [1, 2].sample,
                              longitude:        Faker::Address.longitude,
                              latitude:         Faker::Address.latitude,
                              residential_type: ['Residential', 'Condo', 'Multi-Family'].sample,
                              sale_date:        Date.today - 10.days,
                              price:            [59_000.0, 66_000.0, 75_000.0].sample,
                              sq_ft:            [950, 1500, 1250, 754].sample)

      get "#{api}/estates/#{record.id}"
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      record_data   = json_response['data'].first
      expect(record_data['id']).to eql(record.id)
    end
  end
end
