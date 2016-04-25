class AddGroupIdToImports < ActiveRecord::Migration
  def change
    add_column :imports, :group_id, :integer
    add_index :imports, :group_id
  end
end
