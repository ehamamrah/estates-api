class CreateEstates < ActiveRecord::Migration[5.2]
  def change
    create_table :estates do |t|
      t.string :street
      t.string :city
      t.string :zip
      t.string :state
      t.integer :beds
      t.integer :baths
      t.integer :sq_ft
      t.string :type
      t.date :sale_date
      t.float :price
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
