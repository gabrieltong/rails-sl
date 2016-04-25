class AddStatusToCardTpls < ActiveRecord::Migration
  def change
    add_column :card_tpls, :status, :string
    add_index :card_tpls, :status
    add_column :card_tpls, :total, :integer
    add_index :card_tpls, :total
    add_column :card_tpls, :remain, :integer
  end
end
