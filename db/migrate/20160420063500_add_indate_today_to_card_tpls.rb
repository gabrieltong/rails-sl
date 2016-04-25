class AddIndateTodayToCardTpls < ActiveRecord::Migration
  def change
    add_column :card_tpls, :indate_today, :boolean
    add_index :card_tpls, :indate_today
  end
end
