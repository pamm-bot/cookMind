class AddAvatarToProfils < ActiveRecord::Migration[8.1]
  def change
    add_column :profils, :avatar, :string
  end
end
