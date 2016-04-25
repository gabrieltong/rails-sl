class AddPersonLimitToCardTpls < ActiveRecord::Migration
  def change
    add_column :card_tpls, :person_limit, :integer, {:default=>1}
    add_index :card_tpls, :person_limit
  end
end
