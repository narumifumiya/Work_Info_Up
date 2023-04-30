class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.integer :company_id,       null: false
      t.integer :user_id,          null: false
      t.string :name,              null: false
      t.date :start_date
      t.date :end_date
      t.text :introduction
      t.integer :contract_amount
      t.integer :order_status,    null: false, default: 0
      t.integer :progress_status, null: false, default: 0

      t.timestamps
    end
  end
end
