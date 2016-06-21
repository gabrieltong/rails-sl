class DrawAward < ActiveRecord::Base
	belongs_to :card_tpl
	belongs_to :award_tpl, :class_name=>CardTpl, :foreign_key=>:award_id

	def number_need_create
		number - award_tpl.cards.locked_by_tpl(card_tpl).size
	end

  # validate :
end
