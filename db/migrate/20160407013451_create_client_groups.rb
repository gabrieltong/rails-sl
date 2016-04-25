class CreateClientGroups < ActiveRecord::Migration
  def change
    create_table :client_groups do |t|
      t.integer :client_id
      t.string :title, :default=>''
      t.integer :position
      t.string :desc, :limit=>10000, :default=>''
      t.boolean :active
      t.boolean :default

      t.timestamps null: false
    end
    add_index :client_groups, :client_id
    add_index :client_groups, :position
    add_index :client_groups, :active
    add_index :client_groups, :default
  end
end
