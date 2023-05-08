class Customer < ApplicationRecord
  belongs_to :company

  has_one_attached :customer_image

  scope :latest, -> {order(created_at: :desc)} #descは降順…作成日が新しい順になる(10,9,8...)
  scope :old, -> {order(created_at: :asc)}    #ascは昇順…作成日が古い順になる(1,2,3...)

  validates :name, presence:

  def get_customer_image(width, height)
    unless customer_image.attached?
      file_path = Rails.root.join('app/assets/images/profile.jpg')
      customer_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    customer_image.variant(resize_to_limit: [width, height]).processed
  end

end
