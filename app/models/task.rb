class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :start_time, presence: true
  validate :date_before_start
  
  # 今日より前の日付へは登録、編集できない
  def date_before_start
    if self.start_time.present?
      errors.add(:start_time, "は過去の日付を選択できません") if start_time < Date.today
    end
  end
  
end
