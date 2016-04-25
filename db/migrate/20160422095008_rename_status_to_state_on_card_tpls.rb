class RenameStatusToStateOnCardTpls < ActiveRecord::Migration
  def change
  	rename_column :card_tpls, :status, :state
  end
end
