class CreateManagerShops < ActiveRecord::Migration
  def change
    create_table :manager_shops do |t|
      t.integer :client_manager_id
      t.integer :shop_id

      t.timestamps null: false
    end
    add_index :manager_shops, :client_manager_id
    add_index :manager_shops, :shop_id
    add_index :manager_shops, [:shop_id, :client_manager_id], :unique=>true
  end
end
