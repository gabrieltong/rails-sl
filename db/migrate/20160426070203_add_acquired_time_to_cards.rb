class AddAcquiredTimeToCards < ActiveRecord::Migration
  def change
    add_column :cards, :acquired_time, :time
  end
end
