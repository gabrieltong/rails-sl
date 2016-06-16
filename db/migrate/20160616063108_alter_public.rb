class AlterPublic < ActiveRecord::Migration
  def change
    change_column :card_tpls, :public, :boolean, {:default=>true}
  end
end
