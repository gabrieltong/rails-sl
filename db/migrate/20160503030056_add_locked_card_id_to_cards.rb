class AddLockedCardIdToCards < ActiveRecord::Migration
  def change
    add_column :cards, :locked_id, :integer, :after =>:locked_by_id
    add_index :cards, :locked_id

    add_column :cards, :locked_tpl_id, :integer, :after =>:locked_by_id
    add_index :cards, :locked_tpl_id

    add_column :cards, :locked_by_tpl_id, :integer, :after =>:locked_by_id
    add_index :cards, :locked_by_tpl_id
  end
end
