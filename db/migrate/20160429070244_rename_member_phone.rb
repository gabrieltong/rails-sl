class RenameMemberPhone < ActiveRecord::Migration
  def change
  	rename_column :client_members, :member_phone, :phone
  	rename_column :group_members, :member_phone, :phone
  end
end
