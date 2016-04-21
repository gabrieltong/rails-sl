class CardBTpl < CardTpl
	DrawType = {I18n.t('draw_type.shake')=>'shake', I18n.t('draw_type.scratch')=>'scratch'}
	validates :draw_type, :presence=>true, :inclusion=>{:in=>DrawType.values}
	accepts_nested_attributes_for :draw_awards, :allow_destroy => true
end