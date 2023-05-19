class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_many :chats, dependent: :destroy


  validates :name, presence: true, uniqueness: true
  # active_recordを導入している為、下記にてカラムと同じようにimageを呼び出す事が出来る
  has_one_attached :group_image

  scope :latest, -> {order(created_at: :desc)} #descは降順…作成日が新しい順になる(10,9,8...)
  scope :old, -> {order(created_at: :asc)}    #ascは昇順…作成日が古い順になる(1,2,3...)

  def get_group_image(width, height)
    unless group_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      group_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    group_image.variant(resize_to_limit: [width, height]).processed
  end

  # 検索方法は部分一致のみ
  def self.looks(search, word)
    if search == "partial"
      @group = Group.where("name LIKE?","%#{word}%")
    end
  end

  # グループ参加通知作成メソッド
  def create_notification_join!(current_user)
    # グループメンバー全員を検索
    group_users.each do |temp_id|
      save_notification_join!(current_user, temp_id['user_id'])
    end
  end

  def save_notification_join!(current_user, visited_id)
    # グループ参加は複数人が参加することが考えられるため、複数回通知する
    notification = current_user.active_notifications.new(
      group_id: id,
      visited_id: visited_id,
      action: 'join'
    )
    # 自分へのグループ参加に対しての場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end


  # チャット通知作成メソッド
  def create_notification_chat!(current_user, chat_id)
    # グループメンバー全員を検索
    group_users.each do |temp_id|
      save_notification_chat!(current_user, chat_id, temp_id['user_id'])
    end
  end

  def save_notification_chat!(current_user, chat_id, visited_id)
    # グループチャットは複数人が何回もコメントすることが考えられるため、複数回通知する
    notification = current_user.active_notifications.new(
      group_id: id,
      chat_id: chat_id,
      visited_id: visited_id,
      action: 'chat'
    )
    # 自分へのグループチャットに対しての場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end


end
