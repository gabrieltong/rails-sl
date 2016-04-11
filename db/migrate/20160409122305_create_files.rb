class CreateFiles < ActiveRecord::Migration
  def change
    create_table :files do |t|
    	t.integer :file_owner_id
    	t.string :file_owner_type
    	t.attachment :file
    	t.string :type
    end
  end
end
