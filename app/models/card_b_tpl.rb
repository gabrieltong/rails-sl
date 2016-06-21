class CardBTpl < CardTpl
  DrawType = {I18n.t('draw_type.shake')=>'shake', I18n.t('draw_type.scratch')=>'scratch'}
  validates :draw_type, :presence=>true, :inclusion=>{:in=>DrawType.values}
  accepts_nested_attributes_for :draw_awards, :allow_destroy => true

  alias_method :card_bs, :cards

  validates :draw_awards, :presence=> true

  after_create do |record|
    record.draw_awards.each do |award|
      Quantity.generate_instance_for_award(award)
    end
  end
end