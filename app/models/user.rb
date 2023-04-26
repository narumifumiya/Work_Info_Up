class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :department

  validates :name,           presence: true
  validates :name_kana,      presence: true
  validates :phone_number,   presence: true
end
