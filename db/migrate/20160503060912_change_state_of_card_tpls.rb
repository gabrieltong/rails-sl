class ChangeStateOfCardTpls < ActiveRecord::Migration
  def change
  	change_column :card_tpls, :state, :string, {:default=>:active}
  end
end
