class AddAcquireTypeToCardTpls < ActiveRecord::Migration
  def change
    add_column :card_tpls, :acquire_type, :string
    add_index :card_tpls, :acquire_type
  end
end
