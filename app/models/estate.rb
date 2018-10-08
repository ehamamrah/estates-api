class Estate < ApplicationRecord
  validates_presence_of :street, :city, :zip, :state, :beds, :baths, :sq_ft, :residential_type, :sale_date, :price, :latitude, :longitude

  scope :ordered_by_creation_date, -> { order('created_at DESC') }
  scope :type,                     ->(type)          { where('lower(residential_type) like ?', "#{type.downcase}%") }
  scope :starting_price,           ->(start_price)   { where('price >= :start_price', start_price: start_price.to_f) }
  scope :ending_price,             ->(ending_price)  { where('price <= :ending_price', ending_price: ending_price.to_f) }
  scope :starting_square,          ->(starting_feet) { where('sq_ft >= :starting_feet', starting_feet: starting_feet.to_f) }
  scope :ending_square,            ->(ending_feet)   { where('sq_ft <= :ending_feet', ending_feet: ending_feet.to_f) }

  def self.filter(filtering_params)
    data = where(nil)
    filtering_params.each do |key, value|
      data = data.send(key, value) if value.present?
    end
    data
  end
end
