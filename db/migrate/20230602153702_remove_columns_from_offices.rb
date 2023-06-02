class RemoveColumnsFromOffices < ActiveRecord::Migration[6.1]
  def change
    remove_column :offices, :post_code, :string
    remove_column :offices, :address, :string
  end
end
