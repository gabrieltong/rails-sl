class AddDrawAwardIdToQuantities < ActiveRecord::Migration
  def change
    add_column :quantities, :draw_award_id, :integer
    add_index :quantities, :draw_award_id
  end
end
