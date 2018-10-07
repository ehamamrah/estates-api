class Estate < ApplicationRecord
  validates_presence_of :street, :city, :zip, :state, :beds, :baths, :sq_ft, :residential_type, :sale_date, :price, :latitude, :longitude

  scope :ordered_by_creation_date, -> { order('created_at DESC') }
end
