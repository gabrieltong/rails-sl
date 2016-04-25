class AddMemberPhoneToGroupMembers < ActiveRecord::Migration
  def change
    add_column :group_members, :member_phone, :string
    add_index :group_members, [:member_phone, :group_id], :unique=>true
  end
end
