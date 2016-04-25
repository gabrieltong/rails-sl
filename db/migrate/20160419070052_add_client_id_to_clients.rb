class AddClientIdToClients < ActiveRecord::Migration
  def change
    add_column :imports, :client_id, :integer
    add_index :imports, :client_id
  end
end
