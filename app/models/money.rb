class Money < ActiveRecord::Base
	belongs_to :client_member
	belongs_to :by_member, :class_name=>Member, :foreign_key=>:by_phone

	scope :charge, ->{where("money > 0")}
	scope :spend, ->{where("money < 0")}

	delegate :member, to: :client_member
	delegate :client, to: :client_member

	private
	def self.table_name
		:moneys
	end
end
