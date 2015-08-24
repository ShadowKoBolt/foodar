class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.integer :recipe_id
      t.integer :food_id
      t.float :amount

      t.timestamps null: false
    end
  end
end
