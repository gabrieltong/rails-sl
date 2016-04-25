class CreateQuantities < ActiveRecord::Migration
  def change
    create_table :quantities do |t|
      t.integer :number
      t.integer :card_tpl_id
      t.integer :member_id

      t.timestamps null: false
    end
    add_index :quantities, :number
    add_index :quantities, :card_tpl_id
    add_index :quantities, :member_id
  end
end
