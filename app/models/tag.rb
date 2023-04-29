class Tag < ApplicationRecord
  has_many :project_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :projects, through: :project_tags
end
