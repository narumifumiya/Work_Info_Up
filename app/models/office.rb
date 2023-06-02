class Office < ApplicationRecord
  belongs_to :company

  validates :name, presence: true

  scope :latest, -> {order(created_at: :desc)} #descは降順…作成日が新しい順になる(10,9,8...)
  scope :old, -> {order(created_at: :asc)}    #ascは昇順…作成日が古い順になる(1,2,3...)

  # 郵便番号と住所を同時に表示
  # def total_address
  #   "〒#{post_code}　#{address}"
  # end
  
  # 郵便番号と住所を同時に表示
  def total_address
    "〒#{postcode}　#{self.prefecture_name}#{self.address_city}#{self.address_street}#{self.address_building}"
  end
  
  # 都道府県コードから都道府県名に自動で変換する
  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end
  
end
