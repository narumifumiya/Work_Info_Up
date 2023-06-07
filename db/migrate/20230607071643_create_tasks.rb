class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :content
      t.date :start_time
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
