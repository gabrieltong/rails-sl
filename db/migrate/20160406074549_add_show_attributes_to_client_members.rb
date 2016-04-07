class AddShowAttributesToClientMembers < ActiveRecord::Migration
  def change
    add_column :client_members, :name, :string
    add_column :client_members, :sex, :string
    add_column :client_members, :borned_at, :date
    add_column :client_members, :address, :string
    add_column :client_members, :email, :string
    add_attachment :client_members, :pic
  end
end
