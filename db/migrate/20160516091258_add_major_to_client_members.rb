class AddMajorToClientMembers < ActiveRecord::Migration
  def change
    add_column :client_members, :major, :string, {:default=>''}
    add_index :client_members, :major

    add_column :clients, :major, :boolean, {:default=>true}
    add_index :clients, :major
  end
end
