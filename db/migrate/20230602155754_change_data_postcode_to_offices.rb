class ChangeDataPostcodeToOffices < ActiveRecord::Migration[6.1]
  def change
    change_column :offices, :postcode, :string
  end
end
