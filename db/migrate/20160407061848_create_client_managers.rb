class CreateClientManagers < ActiveRecord::Migration
  def change
    create_table :client_managers do |t|
      t.integer :client_id
      t.integer :member_id
      t.boolean :sender
      t.boolean :admin
      t.boolean :checker

      t.timestamps null: false
    end
    add_index :client_managers, :client_id
    add_index :client_managers, :member_id
    add_index :client_managers, :sender
    add_index :client_managers, :checker
    add_index :client_managers, :admin
  end
end
