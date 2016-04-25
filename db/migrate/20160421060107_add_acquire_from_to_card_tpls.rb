class AddAcquireFromToCardTpls < ActiveRecord::Migration
  def change
    add_column :card_tpls, :acquire_from, :datetime
    add_column :card_tpls, :acquire_to, :datetime
  end
end
