class Department < ApplicationRecord
  has_many :users

  scope :latest, -> {order(created_at: :desc)} #descは降順…作成日が新しい順になる(10,9,8...)
  scope :old, -> {order(created_at: :asc)}    #ascは昇順…作成日が古い順になる(1,2,3...)

  validates :name, presence: true

  # コールバック（部署が削除後にメソッドを発動）
  after_destroy :user_has_a_value?

  private

  # 部署が削除された時にその部署IDを持っているユーザーがいたら
  # そのユーザーのdepartment_idをnilに変更する。
  def user_has_a_value?
    self.destroy
    if User.where(department_id: self.id).exists?
      user = User.where(department_id: self.id)
      user.update(department_id: nil)
    end
  end

end
