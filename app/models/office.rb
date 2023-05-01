class Office < ApplicationRecord

  belongs_to :company

  validates :name, presence: true
  
  # 郵便番号と住所を同時に表示
  def total_address
    "〒#{post_code}　#{address}"
  end

end
