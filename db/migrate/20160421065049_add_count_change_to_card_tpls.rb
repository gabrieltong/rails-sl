class AddCountChangeToCardTpls < ActiveRecord::Migration
  def change
    add_column :card_tpls, :count_change, :integer
    add_index :card_tpls, :count_change
  end
end
