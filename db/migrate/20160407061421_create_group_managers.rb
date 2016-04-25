class CreateGroupManagers < ActiveRecord::Migration
  def change
    create_table :group_managers do |t|
      t.integer :group_id
      t.integer :member_id
      t.boolean :send
      t.boolean :admin
      t.boolean :check

      t.timestamps null: false
    end
    add_index :group_managers, :group_id
    add_index :group_managers, :member_id
    add_index :group_managers, :send
    add_index :group_managers, :admin
    add_index :group_managers, :check
    add_index :group_managers, [:group_id, :member_id], :unique=>true
  end
end
