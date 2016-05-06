class ChangeMemberIdOfMoneys < ActiveRecord::Migration
  def change
  	add_column :moneys, :phone, :string, {:null=>false}
  	add_index :moneys, :phone
  	remove_column :moneys, :member_id
  end
end
