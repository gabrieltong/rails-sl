class DropTables < ActiveRecord::Migration
  def change
  	drop_table :client_group_members
  	drop_table :client_groups
  	drop_table :client_shops
  	drop_table :client_users
  	drop_table :users
  end
end
