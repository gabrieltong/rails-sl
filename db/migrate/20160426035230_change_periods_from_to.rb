class ChangePeriodsFromTo < ActiveRecord::Migration
  def change
  	change_column :periods, :from, :time
  	change_column :periods, :to, :time
  end
end
