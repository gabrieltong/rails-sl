class AddTypeToGabeDayus < ActiveRecord::Migration
  def change
    add_column :gabe_dayus, :type, :string
    add_index :gabe_dayus, :type
  end
end
