class CreateClientGroupMembers < ActiveRecord::Migration
  def change
    create_table :client_group_members do |t|
      t.integer :client_group_id
      t.integer :member_id
      t.date :started_at
      t.date :ended_at
      t.timestamps null: false
    end
    add_index :client_group_members, [:client_group_id,:member_id], :unique=>true
  end
end
