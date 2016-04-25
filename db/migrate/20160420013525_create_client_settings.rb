class CreateClientSettings < ActiveRecord::Migration
  def change
    create_table :client_settings do |t|
      t.integer :client_id
      t.boolean :show_name
      t.boolean :show_phone
      t.boolean :show_borned_at
      t.boolean :show_pic
      t.boolean :show_address
      t.boolean :show_email

      t.timestamps null: false
    end
    add_index :client_settings, :client_id
    add_index :client_settings, :show_name
    add_index :client_settings, :show_phone
    add_index :client_settings, :show_borned_at
    add_index :client_settings, :show_pic
    add_index :client_settings, :show_address
    add_index :client_settings, :show_email
  end
end
