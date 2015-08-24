class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.integer :user_id
      t.date :start_date
      t.date :end_date
      t.string :name

      t.timestamps null: false
    end
  end
end
