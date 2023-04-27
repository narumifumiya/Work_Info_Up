class CreateOffices < ActiveRecord::Migration[6.1]
  def change
    create_table :offices do |t|
      t.integer :company_id,    null: false
      t.string :name,           null: false
      t.string :post_code
      t.string :address
      t.string :phone_number

      t.timestamps
    end
  end
end
