class AddMemberIdToCardTpls < ActiveRecord::Migration
  def change
    add_column :card_tpls, :member_id, :integer
    add_index :card_tpls, :member_id
  end
end
