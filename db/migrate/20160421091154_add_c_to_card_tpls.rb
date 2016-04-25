class AddCToCardTpls < ActiveRecord::Migration
  def change
    add_column :card_tpls, :public, :boolean
    add_index :card_tpls, :public
    add_column :card_tpls, :allow_share, :boolean
    add_index :card_tpls, :allow_share
  end
end
