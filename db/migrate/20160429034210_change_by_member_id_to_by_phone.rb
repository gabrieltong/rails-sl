class ChangeByMemberIdToByPhone < ActiveRecord::Migration
  def change
  	rename_column :moneys, :by_member_id, :by_phone
  end
end
