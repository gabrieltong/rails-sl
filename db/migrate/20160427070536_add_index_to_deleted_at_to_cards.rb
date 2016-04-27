class AddIndexToDeletedAtToCards < ActiveRecord::Migration
  def change
  	add_index :cards, :deleted_at
  end
end
