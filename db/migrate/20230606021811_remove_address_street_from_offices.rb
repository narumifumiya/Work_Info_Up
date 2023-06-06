class RemoveAddressStreetFromOffices < ActiveRecord::Migration[6.1]
  def change
    remove_column :offices, :address_street, :string
  end
end
