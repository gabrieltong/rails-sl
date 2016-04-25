class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :title
      t.integer :importable_id
      t.string :importable_type
      t.string :type

      t.timestamps null: false
    end
    add_index :imports, :importable_id
    add_index :imports, :importable_type
    add_index :imports, :type
    add_attachment :imports, :file
  end
end
