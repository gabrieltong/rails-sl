# encoding: UTF-8
class CardTplShop < ActiveRecord::Base
  belongs_to :card_tpl
  belongs_to :shop

# 本来应该向card_tpl_id添加验证，但由于在一个表单内 ，验证card_tpl_id时，card_tpl_id还不存在，所以验证会一直失败
  # validates :card_tpl_id, :shop_id, :presence=>true
  validates :shop_id, :presence=>true
  validates :card_tpl_id, :uniqueness=>{:scope=>:shop_id}
end
