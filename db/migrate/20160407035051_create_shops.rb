class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.integer :client_id
      t.string :title
      t.string :address
      t.string :phone
      t.float :x
      t.float :y

      t.timestamps null: false
    end
    add_index :shops, :client_id
  end
end
