class CreateCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :customers do |t|
      t.integer :company_id,   null: false
      t.string :name,          null: false
      t.string :phone_number
      t.string :email
      t.string :position
      t.string :department

      t.timestamps
    end
  end
end
