class ChangeCardTplsInactive < ActiveRecord::Migration
  def change
  	change_column :card_tpls, :state, :string, {:default=>'inactive'}
  end
end
