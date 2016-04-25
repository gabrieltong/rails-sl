class CreateCardTplShops < ActiveRecord::Migration
  def change
    create_table :card_tpl_shops do |t|
      t.integer :card_tpl_id
      t.integer :shop_id
      t.integer :client_id

      t.timestamps null: false
    end
    add_index :card_tpl_shops, :card_tpl_id
    add_index :card_tpl_shops, :shop_id
    add_index :card_tpl_shops, :client_id
  end
end
