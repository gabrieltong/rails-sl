class RemoveShopIdOnClientManagers < ActiveRecord::Migration
  def up
    remove_column :client_managers, :shop_id
  end

  def down
    add_column :client_managers, :shop_id, :integer
  end
end
