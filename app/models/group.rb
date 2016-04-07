class Group < ActiveRecord::Base
	belongs_to :client
	has_many :group_member
	has_many :members
	
	validates :title, :position, :desc, :active, :presence=>true

	def self.permit_params
		[:client_id,:title,:position,:desc,:active,:default]
	end	
end
