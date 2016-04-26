class AddCheckerIdToCards < ActiveRecord::Migration
  def change
    add_column :cards, :checker_phone, :string, {:limit=>11}
    add_index :cards, :checker_phone
    add_column :cards, :sender_phone, :string, {:limit=>11}
    add_index :cards, :sender_phone
  end
end
