class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :department,       optional: true
  has_many   :projects
  has_many   :project_comments, dependent: :destroy
  has_many   :favorites,        dependent: :destroy
  has_many   :group_users,      dependent: :destroy
  has_many   :groups,           through: :group_users

  has_one_attached :profile_image

  validates :name,           presence: true
  validates :name_kana,      presence: true
  validates :phone_number,   presence: true

   scope :latest, -> {order(created_at: :desc)} #descは降順…作成日が新しい順になる(10,9,8...)
   scope :old, -> {order(created_at: :asc)}    #ascは昇順…作成日が古い順になる(1,2,3...)

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/profile.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  # 検索方法は部分一致のみ
  def self.looks(search, word)
    if search == "partial"
      @user = User.where("name LIKE?","%#{word}%")
    end
  end

  # ゲストログイン時に使用する
  def self.guest
    find_or_create_by!(name: 'guestuser' ,email: 'guest@example.com' ,name_kana: 'ゲストユーザー' , phone_number: '00000000000' ) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end

  

end
