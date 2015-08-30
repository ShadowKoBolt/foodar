class CreateListItems < ActiveRecord::Migration
  def change
    create_table :list_items do |t|
      t.integer :list_id
      t.string :name
      t.string :aisle

      t.timestamps null: false
    end
  end
end
