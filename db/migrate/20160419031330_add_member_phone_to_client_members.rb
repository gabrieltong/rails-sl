class AddMemberPhoneToClientMembers < ActiveRecord::Migration
  def change
    add_column :client_members, :member_phone, :string
    add_index :client_members, [:member_phone, :client_id], :unique=>true
  end
end
