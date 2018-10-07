class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :estates, :type, :residential_type
  end
end
