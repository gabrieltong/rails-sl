class RemoveChangeRemain < ActiveRecord::Migration
  def change
  	remove_column :card_tpls, :change_remain
  end
end
