class AddClientIdToGroupMembers < ActiveRecord::Migration
  def change
    add_column :group_members, :client_id, :integer
    add_index :group_members, :client_id
  end
end
