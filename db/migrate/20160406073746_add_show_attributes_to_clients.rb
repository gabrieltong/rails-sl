class AddShowAttributesToClients < ActiveRecord::Migration
  def change
    add_column :clients, :show_name, :boolean
    add_column :clients, :show_phone, :boolean
    add_column :clients, :show_sex, :boolean
    add_column :clients, :show_borded_at, :boolean
    add_column :clients, :show_pic, :boolean
    add_column :clients, :show_address, :boolean
    add_column :clients, :show_email, :boolean
  end
end
