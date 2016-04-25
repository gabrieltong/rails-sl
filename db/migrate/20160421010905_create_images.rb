class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :imageable_id
      t.string :imageable_type
      t.integer :member_id
      t.integer :client_id

      t.timestamps null: false
    end
    add_index :images, [:imageable_id,:imageable_type]
    add_index :images, :member_id
    add_index :images, :client_id
    add_attachment :images, :file
  end
end
