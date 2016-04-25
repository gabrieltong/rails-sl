class CreateClientUsers < ActiveRecord::Migration
  def change
    create_table :client_users do |t|
      t.integer :client_id
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :client_users, :client_id
    add_index :client_users, :user_id
  end
end
