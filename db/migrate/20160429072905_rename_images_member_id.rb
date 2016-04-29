class RenameImagesMemberId < ActiveRecord::Migration
  def change
  	change_column :images, :member_id, :string, {:limit=>15}
  	rename_column :images, :member_id, :phone
  end
end
