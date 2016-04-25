class AddIsSpToClients < ActiveRecord::Migration
  def change
    add_column :clients, :is_sp, :boolean
    add_index :clients, :is_sp

    add_column :clients, :sp_id, :integer
  end
end
