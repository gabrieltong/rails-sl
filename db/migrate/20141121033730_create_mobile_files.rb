class CreateMobileFiles < ActiveRecord::Migration
  def change
    create_table :mobile_files do |t|
      t.integer :user_id
      t.string :type

      t.timestamps
    end
    add_index :mobile_files, :user_id
    add_index :mobile_files, :type
    add_attachment :mobile_files, :file
  end
end
