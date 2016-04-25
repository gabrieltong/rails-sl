class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :type, :default=>'', :null=>false, :limit=>10
      t.integer :card_tpl_id
      t.string :code, :default=>'', :null=>false, :limit=>20
      t.string :state, :default=>'', :null=>false, :limit=>10
      t.datetime :deleted_at
      t.integer :card_a_id
      t.string :phone, :default=>'', :null=>false, :limit=>20
      t.datetime :acquired_at
      t.datetime :checked_at
      
      t.timestamps null: false
    end
    add_index :cards, :card_tpl_id
    add_index :cards, :phone
    add_index :cards, :state
    add_index :cards, :type
    add_index :cards, :code, :unique=>true
  end
end
