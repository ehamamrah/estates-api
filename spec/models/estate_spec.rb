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
                       beds:             3,
                       baths:            2,
                       longitude:        Faker::Address.longitude,
                       latitude:         Faker::Address.latitude,
                       residential_type: 'Residential',
                       sale_date:        Date.today - 10.days,
                       price:            59000.0,
                       sq_ft:            1500)
      end
    end

    it 'will return last created real estate based on ordered_by_creation_date scope' do
      expect(Estate.ordered_by_creation_date.first).to eq(Estate.last)
    end
  end
end
