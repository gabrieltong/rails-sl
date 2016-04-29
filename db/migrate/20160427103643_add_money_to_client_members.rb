class AddMoneyToClientMembers < ActiveRecord::Migration
  def change
    add_column :client_members, :money, :float, {:default=>0, :null=>false}
  end
end
