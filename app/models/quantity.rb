class Quantity < ActiveRecord::Base
	belongs_to :card_tpl
	belongs_to :member

	counter_culture :card_tpl, :column_name => 'total', :delta_column => 'number'
	counter_culture :card_tpl, :column_name => 'remain', :delta_column => 'number'

	validates :number, :numericality => {:only_integer => true, :other_than=>0}
	validates :number, :card_tpl_id, :presence=>true
end
