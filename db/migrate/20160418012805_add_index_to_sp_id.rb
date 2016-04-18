class AddIndexToSpId < ActiveRecord::Migration
  def change
  	add_index :clients, :sp_id
  end
end
