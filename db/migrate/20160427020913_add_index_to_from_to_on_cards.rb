class AddIndexToFromToOnCards < ActiveRecord::Migration
  def change
  	add_index :cards, :from
  	add_index :cards, :to
  end
end
