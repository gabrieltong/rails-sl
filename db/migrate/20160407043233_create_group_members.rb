class CreateGroupMembers < ActiveRecord::Migration
  def change
    create_table :group_members do |t|
      t.integer :group_id
      t.integer :member_id
      t.date :started_at
      t.date :ended_at

      t.timestamps null: false
    end
    add_index :group_members, :group_id
    add_index :group_members, :member_id
  end
end
