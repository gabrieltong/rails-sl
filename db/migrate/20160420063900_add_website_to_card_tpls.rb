class AddWebsiteToCardTpls < ActiveRecord::Migration
  def change
    add_column :card_tpls, :website, :string
  end
end
