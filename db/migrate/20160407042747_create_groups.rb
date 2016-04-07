class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :client_id
      t.string :title, :default=>''
      t.integer :position, :default=>0
      t.string :desc, :limit=>10000, :default=>''
      t.boolean :active, :default=>1
      t.boolean :default, :default=>0

      t.timestamps null: false
    end
    add_index :groups, :client_id
    add_index :groups, :active
    add_index :groups, :default
  end
end
