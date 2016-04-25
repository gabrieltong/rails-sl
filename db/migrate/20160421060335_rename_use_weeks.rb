class RenameUseWeeks < ActiveRecord::Migration
  def change
  	rename_column :card_tpls, :use_weeks, :check_use_weeks
  	add_column :card_tpls, :acquire_use_weeks, :string
  end
end
