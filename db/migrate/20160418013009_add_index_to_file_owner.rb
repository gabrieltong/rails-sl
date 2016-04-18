class AddIndexToFileOwner < ActiveRecord::Migration
  def change
  	add_index :files, [:file_owner_id, :file_owner_type]
  end
end
