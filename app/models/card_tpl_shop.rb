class CardTplShop < ActiveRecord::Base
  belongs_to :card_tpl
  belongs_to :shop

  validates :card_tpl_id, :shop_id, :presence=>true
  validates :card_tpl_id, :uniqueness=>{:scope=>:shop_id}
end
