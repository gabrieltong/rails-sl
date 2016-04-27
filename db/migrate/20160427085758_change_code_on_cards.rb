class ChangeCodeOnCards < ActiveRecord::Migration
  def change
  	# remove_index :cards, :code
  	# change_column :cards, :code, :string, {:null=>true, :default=>nil}
  	add_index :cards, :code, :unique=>true
  end
end
