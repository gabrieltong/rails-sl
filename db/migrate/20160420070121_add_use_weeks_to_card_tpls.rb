class AddUseWeeksToCardTpls < ActiveRecord::Migration
  def change
    add_column :card_tpls, :use_weeks, :string
    add_column :card_tpls, :use_hours, :string
  end
end
