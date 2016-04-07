class RemoveIndexOnMembers < ActiveRecord::Migration
  def change
  	remove_index :members, :email
  end
end
