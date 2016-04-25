class CreateCardTpls < ActiveRecord::Migration
  def change
    create_table :card_tpls do |t|
      t.integer :client_id
      t.string :title
      t.string :desc
      t.string :discount_desc
      t.string :discount_intro
      t.string :type
      t.string :indate_type
      t.datetime :indate_from
      t.datetime :indate_to
      t.integer :indate_after

      t.timestamps null: false
    end
    add_index :card_tpls, :client_id
    add_index :card_tpls, :type
    add_index :card_tpls, :indate_type
  end
end
