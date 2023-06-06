class AddColumnsToOffices < ActiveRecord::Migration[6.1]
  def change
    add_column :offices, :postcode, :integer
    add_column :offices, :prefecture_code, :integer
    add_column :offices, :address_city, :string
    add_column :offices, :address_street, :string
    add_column :offices, :address_building, :string
  end
end
