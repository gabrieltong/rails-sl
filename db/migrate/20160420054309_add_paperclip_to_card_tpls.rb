class AddPaperclipToCardTpls < ActiveRecord::Migration
  def change
  	add_attachment :card_tpls, :cover
  	add_attachment :card_tpls, :share_cover
  	add_attachment :card_tpls, :guide_cover
  end
end
