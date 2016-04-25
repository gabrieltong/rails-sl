class AddAddQuantityIdToCards < ActiveRecord::Migration
  def change
    add_column :cards, :added_quantity_id, :integer
    add_index :cards, :added_quantity_id
    add_column :cards, :removed_quantity_id, :integer
    add_index :cards, :removed_quantity_id
    add_column :cards, :client_id, :integer
    add_index :cards, :client_id
  end
end
