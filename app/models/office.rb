class Office < ApplicationRecord

  belongs_to :company

  validates :name, presence: true
  
  scope :latest, -> {order(created_at: :desc)} #descは降順…作成日が新しい順になる(10,9,8...)
  scope :old, -> {order(created_at: :asc)}    #ascは昇順…作成日が古い順になる(1,2,3...)
  
  # 郵便番号と住所を同時に表示
  def total_address
    "〒#{post_code}　#{address}"
  end

end
