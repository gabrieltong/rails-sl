class AddPhoneToClientManager < ActiveRecord::Migration
  def change
    add_column :client_managers, :phone, :string
    add_index :client_managers, :phone
    add_column :client_managers, :name, :string
  end
end
