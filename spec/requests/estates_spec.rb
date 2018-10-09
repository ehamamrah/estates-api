require 'rails_helper'

RSpec.describe 'Api V1 Estates', type: :request do
  let(:api)          { '/api/v1/estates' }
  let(:valid_params) { {  street:           Faker::Address.street_name,
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
                          sq_ft:            [950, 1500, 1250, 754].sample } }

  describe 'GET /estates' do
    before(:each) do
      5.times do
        Estate.create!(valid_params)
      end
      get "#{api}"
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
        Estate.create!(valid_params)
      end
    end

    it 'will retrieve records based on given filters' do
      get "#{api}/search?starting_price=150000"
      search_response = JSON.parse(response.body)
      expect(search_response['data'].count).to eql(0)
    end

    it 'will retrieve records based on given pricing filters' do
      get "#{api}/search?starting_price=45000&&ending_price=100000"
      search_response = JSON.parse(response.body)
      expect(search_response['data'].count).to eql(5)
    end

    it 'will retrieve records based on given type filters' do
      get "#{api}/search?type=unknown"
      search_response = JSON.parse(response.body)
      expect(search_response['data']).to eql([])
    end

    it 'will retrieve records based on given squares filters' do
      get "#{api}/search?starting_square=650&&ending_square=1800"
      search_response = JSON.parse(response.body)
      expect(search_response['data'].count).to eql(5)
    end
  end

  describe '#Show' do
    it 'will show specific real estate details' do
      record = Estate.create!(valid_params)

      get "#{api}/#{record.id}"
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response['data']['id']).to eql(record.id)
    end

    it 'will return failed for a record which not created' do
      get "#{api}/54879"
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eql('Failed')
    end
  end

  describe 'POST #Create' do
    it 'create new real estate' do
      post "#{api}", params: { estate: valid_params }
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eql('Success')
      expect(json_response['data']['id']).to eql(Estate.last.id)
    end
  end

  describe 'PATCH #Update' do
    it 'update existing real estate' do
      record = Estate.create!(valid_params)
      patch "#{api}/#{record.id}", params: { estate: { city: 'Amman' } }
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eql('Success')
      expect(Estate.last.city).to eql('Amman')
    end
  end

  describe '#DELETE record' do
    it 'delete existing real estate' do
      2.times { Estate.create!(valid_params) }
      delete "#{api}/#{Estate.last.id}"
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eql('Success')
      expect(Estate.count).to eql(1)
    end
  end
end
