class Profil < ApplicationRecord
  belongs_to :user

  serialize :ingredients, Array
end
