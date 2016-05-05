class AddClientIdToCapchas < ActiveRecord::Migration
  def change
    add_column :capchas, :client_id, :integer
    add_index :capchas, :client_id
  end
end
