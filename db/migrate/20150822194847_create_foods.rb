class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.string :name
      t.string :unit_name
      t.string :aisle
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
