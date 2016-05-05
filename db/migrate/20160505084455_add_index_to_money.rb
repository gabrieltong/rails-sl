class AddIndexToMoney < ActiveRecord::Migration
  def change
  	add_index :moneys, :money
  end
end
