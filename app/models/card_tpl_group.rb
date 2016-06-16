class CardTplGroup < ActiveRecord::Base
  belongs_to :card_tpl
  belongs_to :group

  # validates :card_tpl_id, :group_id, :presence=>true
  # validates :card_tpl_id, :uniqueness=>{:scope=>:group_id}
end
