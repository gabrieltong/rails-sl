class AddDrawTypeToCardTpls < ActiveRecord::Migration
  def change
    add_column :card_tpls, :draw_type, :string
    add_index :card_tpls, :draw_type
  end
end
