class ClientManager < ActiveRecord::Base
	belongs_to :client
	belongs_to :manager, :class_name=>:Member, :foreign_key=>:member_id

	scope :admin, ->{where(:admin=>true)}
	scope :sender, ->{where(:sender=>true)}
	scope :checker, ->{where(:checker=>true)}

	validates :phone, :name, :client_id, :member_id, :presence=>true

	def self.permit_params
		[:phone, :name, :group_id, :member_id, :admin, :checker, :sender]
	end	
end
