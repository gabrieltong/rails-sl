class AddIndexToFromTo < ActiveRecord::Migration
  def change
  	add_index :periods, :from
  	add_index :periods, :to
  end
end
