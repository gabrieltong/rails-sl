class RemoveWeekZh < ActiveRecord::Migration
  def change
  	remove_column :card_tpls, :use_weeks_zh
  	remove_column :card_tpls, :use_hours_zh
  end
end
