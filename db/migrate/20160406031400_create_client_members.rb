class CreateClientMembers < ActiveRecord::Migration
  def change
    create_table :client_members do |t|
      t.integer :client_id
      t.integer :member_id

      t.timestamps null: false
    end
    add_index :client_members, [:client_id,:member_id], :unique=>true
  end
end
