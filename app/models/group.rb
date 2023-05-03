class Group < ApplicationRecord

  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_many :chats, dependent: :destroy

  validates :name, presence: true
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

end
