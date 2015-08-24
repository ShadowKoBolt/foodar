class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.integer :recipe_id
      t.date :date
      t.string :time
      t.float :serves
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
