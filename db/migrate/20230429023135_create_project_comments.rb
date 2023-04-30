class CreateProjectComments < ActiveRecord::Migration[6.1]
  def change
    create_table :project_comments do |t|
      t.integer :project_id
      t.integer :user_id
      t.text :comment

      t.timestamps
    end
  end
end
