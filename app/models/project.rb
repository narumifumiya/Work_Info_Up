class Project < ApplicationRecord

  belongs_to :company
  belongs_to :user
  has_many   :project_comments, dependent: :destroy
  has_many   :favorites       , dependent: :destroy
  has_many   :project_tags    , dependent: :destroy
  has_many   :tags            , through: :project_tags

  has_one_attached :project_image

  enum order_status: { under_negotiation: 0, ordered: 1, lost_orders: 2 }
  enum progress_status: { not_started_yet: 0, while_working: 1, completion: 2 }

  validates :name, presence: true
  # validates :start_date, presence: true
  # validates :end_date, presence: true
   validate :start_end_check

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

end
