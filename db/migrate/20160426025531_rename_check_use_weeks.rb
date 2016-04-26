class RenameCheckUseWeeks < ActiveRecord::Migration
  def change
  	rename_column :card_tpls, :check_use_weeks, :check_weeks
  	rename_column :card_tpls, :use_hours, :check_hours
  	rename_column :card_tpls, :acquire_use_weeks, :acquire_weeks
  end
end
