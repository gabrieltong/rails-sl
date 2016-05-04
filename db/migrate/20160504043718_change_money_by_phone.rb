class ChangeMoneyByPhone < ActiveRecord::Migration
  def change
  	change_column :moneys, :by_phone, :string, {:limit=>20}
  end
end
