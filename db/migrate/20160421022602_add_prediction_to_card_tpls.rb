class AddPredictionToCardTpls < ActiveRecord::Migration
  def change
    add_column :card_tpls, :prediction, :integer
  end
end
