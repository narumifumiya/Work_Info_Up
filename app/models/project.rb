class Project < ApplicationRecord

  belongs_to :company
  belongs_to :user
  has_many   :project_comments, dependent: :destroy
  has_many   :favorites       , dependent: :destroy

  has_one_attached :project_image

  enum order_status: { under_negotiation: 0, ordered: 1, lost_orders: 2 }
  enum progress_status: { not_started_yet: 0, while_working: 1, completion: 2 }

  validates :name, presence: true

  def get_project_image(width, height)
    unless project_image.attached?
      file_path = Rails.root.join('app/assets/images/mitumori.png')
      project_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    project_image.variant(resize_to_limit: [width, height]).processed
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

end
