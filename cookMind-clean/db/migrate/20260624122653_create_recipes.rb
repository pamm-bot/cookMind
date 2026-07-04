class CreateRecipes < ActiveRecord::Migration[8.1]
  def change
    create_table :recipes do |t|
      t.string :title
      t.text :content
      t.text :ingredients
      t.integer :calories
      t.string :meal_type
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
