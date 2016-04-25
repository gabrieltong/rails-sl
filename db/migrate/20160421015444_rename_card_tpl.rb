class RenameCardTpl < ActiveRecord::Migration
  def change
  	rename_column :card_tpls, :desc, :short_desc
  	rename_column :card_tpls, :discount_desc, :desc
  	rename_column :card_tpls, :discount_intro, :intro
  end
end
