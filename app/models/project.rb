class Project < ApplicationRecord
  belongs_to :company
  belongs_to :user
  has_many   :project_comments, dependent: :destroy
  has_many   :favorites       , dependent: :destroy
  has_many   :project_tags    , dependent: :destroy
  has_many   :tags            , through: :project_tags
  # 通知用
  has_many :notifications, dependent: :destroy

  has_one_attached :project_image

  enum order_status: { under_negotiation: 0, ordered: 1, lost_orders: 2 }
  enum progress_status: { not_started_yet: 0, while_working: 1, completion: 2 }

  validates :name, presence: true, uniqueness: true
  validates :introduction, length: { maximum: 140 }
  validate :start_end_check

  scope :latest, -> {order(created_at: :desc)} #descは降順…作成日が新しい順になる(10,9,8...)
  scope :old, -> {order(created_at: :asc)}    #ascは昇順…作成日が古い順になる(1,2,3...)

  def get_project_image(width, height)
    unless project_image.attached?
      file_path = Rails.root.join('app/assets/images/mitumori.png')
      project_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    project_image.variant(resize_to_limit: [width, height]).processed
  end

  # ユーザーがいいねをしているかを確認
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  # 開始日と終了日の逆転を防ぐ
  def start_end_check
    if self.start_date.present? && self.end_date.present?
      errors.add(:end_date, "は開始日より前の日付は登録できません。") unless
      self.start_date < self.end_date
    end
  end

  def save_tags(sent_tags)
    # タグが存在してるか？確認し、あれば現在projectの持っているタグを引っ張ってきている
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
    # 現在projectが持っているタグと今回入力されたものの差をすでにあるタグとする。古いタグは消す。
    old_tags = current_tags - sent_tags
    # 今回入力されたものと現在存在するタグの差を新しいタグとする。新しいタグは保存
    new_tags = sent_tags - current_tags

    # 古いタグを消す（要らなくなったタグを削除）
    old_tags.each do |old|
      self.tags.delete Tag.find_by(tag_name:old)
    end

    # 新しいタグを保存
    new_tags.each do |new|
     new_project_tag = Tag.find_or_create_by(tag_name: new)
     # 配列に保存
     self.tags << new_project_tag
    end
  end

  # 検索方法は部分一致のみ
  def self.looks(search, word)
    if search == "partial"
      @project = Project.where("name LIKE?","%#{word}%")
    end
  end
  
  # いいね通知作成メソッド
  def create_notification_favorite!(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and project_id = ? and action = ? ", current_user.id, user_id, id, 'favorite'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        project_id: id,
        visited_id: user_id,
        action: 'favorite'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end
  
  # コメント通知作成メソッド
  def create_notification_comment!(current_user, project_comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = ProjectComment.select(:user_id).where(project_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, project_comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, project_comment_id, user_id) if temp_ids.blank?
  end
  
  def save_notification_comment!(current_user, project_comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      project_id: id,
      project_comment_id: project_comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

end
