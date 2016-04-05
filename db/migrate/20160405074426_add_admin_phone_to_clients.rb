class AddAdminPhoneToClients < ActiveRecord::Migration
  def change
    add_column :clients, :admin_phone, :string
  end
end
