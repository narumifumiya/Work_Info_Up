class AddChatIdToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :chat_id, :integer

    add_index :notifications, :chat_id
  end
end
