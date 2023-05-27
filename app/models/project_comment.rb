class ProjectComment < ApplicationRecord
  belongs_to :user
  belongs_to :project
  has_many :notifications, dependent: :destroy

  validates :comment, presence: true, length: { maximum: 140 }

end
