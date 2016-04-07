class AddGroupIdToClientManagers < ActiveRecord::Migration
  def change
    add_column :client_managers, :shop_id, :integer
    add_index :client_managers, :shop_id
  end
end
