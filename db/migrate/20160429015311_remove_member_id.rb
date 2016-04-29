class RemoveMemberId < ActiveRecord::Migration
  def change
  	remove_index :client_members, [:client_id, :member_id]
  	remove_column :client_members, :member_id
  end
end
