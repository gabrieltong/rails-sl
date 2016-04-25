class CreateCardTplGroups < ActiveRecord::Migration
  def change
    create_table :card_tpl_groups do |t|
      t.integer :card_tpl_id
      t.integer :group_id
      t.integer :client_id

      t.timestamps null: false
    end
    add_index :card_tpl_groups, :card_tpl_id
    add_index :card_tpl_groups, :group_id
    add_index :card_tpl_groups, :client_id
  end
end
