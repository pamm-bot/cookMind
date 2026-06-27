class User < ApplicationRecord
  has_one :profil, dependent: :destroy
  has_many :recipes, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :ingredients

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
