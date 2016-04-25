class AddUniqueIndexToGroupTitle < ActiveRecord::Migration
  def change
  	add_index :groups, [:client_id, :title], :unique=>true
  end
end
