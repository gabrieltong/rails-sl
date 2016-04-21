class DrawAward < ActiveRecord::Base
	belongs_to :card_tpl
	belongs_to :award, :class_name=>CardTpl, :foreign_key=>:award_id
end
