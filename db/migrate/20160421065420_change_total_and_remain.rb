class ChangeTotalAndRemain < ActiveRecord::Migration
  def change
  	change_column :card_tpls, :total, :integer, {:default=>0}
  	change_column :card_tpls, :remain, :integer, {:default=>0}
  	change_column :card_tpls, :count_change, :integer, {:default=>0}
  	rename_column :card_tpls, :count_change, :change_remain
  end
end
