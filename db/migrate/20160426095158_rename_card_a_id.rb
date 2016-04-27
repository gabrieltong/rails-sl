class RenameCardAId < ActiveRecord::Migration
  def change
  	rename_column :cards, :card_a_id, :locked_by_id
  end
end
