class AddUseWeeksZhToCardTpls < ActiveRecord::Migration
  def change
    add_column :card_tpls, :use_weeks_zh, :string
    add_column :card_tpls, :use_hours_zh, :string
  end
end
