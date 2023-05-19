class Notification < ApplicationRecord
  # 通知を作成日時の降順にする
  default_scope -> { order(created_at: :desc) }
  belongs_to :project, optional: true
  belongs_to :project_comment, optional: true
  belongs_to :group, optional: true 
  belongs_to :chat, optional: true
  # visitor　通知を送ったユーザー
  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
  # visited　通知を送られたユーザー
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true

end
