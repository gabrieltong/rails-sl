class AddIndexToLockedById < ActiveRecord::Migration
  def change
  	add_index :cards, :locked_by_id
  end
end
