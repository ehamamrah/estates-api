require 'rails_helper'

RSpec.describe Estate, type: :model do
  describe '#Validations' do
    it { is_expected.to validate_presence_of(:street) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:zip) }
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to validate_presence_of(:beds) }
    it { is_expected.to validate_presence_of(:baths) }
    it { is_expected.to validate_presence_of(:sq_ft) }
    it { is_expected.to validate_presence_of(:residential_type) }
    it { is_expected.to validate_presence_of(:sale_date) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_presence_of(:longitude) }
  end

  describe '#Scopes' do
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
                       price:            [59000.0, 66000.0, 75000.0].sample,
                       sq_ft:            [950, 1500, 1250, 754].sample)
      end
    end

    it 'will return last created real estate based on ordered_by_creation_date scope' do
      expect(Estate.ordered_by_creation_date.first).to eq(Estate.last)
    end

    it 'will return records based on given price range' do
      expect(Estate.starting_price(59000).ending_price(80000).count).to eql(Estate.all.count)
      new_modified_estate = Estate.last
      new_modified_estate.update_attributes(price: 150000)
      expect(Estate.starting_price(90000).ending_price(150000)).to include(new_modified_estate)
    end

    it 'will return records based on given price range' do
      expect(Estate.starting_square(700).ending_square(2000).count).to eql(Estate.all.count)
      new_modified_estate = Estate.last
      new_modified_estate.update_attributes(sq_ft: 3000)
      expect(Estate.starting_square(2500).ending_square(3000)).to include(new_modified_estate)
    end

    it 'will return records based on given residential type' do
      new_modified_estate = Estate.last
      new_modified_estate.update_attributes(residential_type: 'Unknown')
      expect(Estate.type('Unknown').count).to eql(1)
    end
  end
end
