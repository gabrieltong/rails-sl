class GroupMember < ActiveRecord::Base
	belongs_to :group
	belongs_to :member, :primary_key=>:phone, :foreign_key=>:member_phone
	belongs_to :client_member, ->(gm){where("client_id = ?", gm.client_id)}, :primary_key=>:member_phone, :foreign_key=>:member_phone
	validates :client_id, :group_id, :member_phone, :started_at, :ended_at, :presence=>true

	scope :by_client, Proc.new {|client_id| where(:client_id=>client_id)}

	before_validation do |gm|
		gm.client_id = gm.group.client_id if gm.group
	end

	after_create do |gm|
		gm.generate_client_member
	end

	def generate_client_member
		if client_member.nil? and client_id and member_phone 
			cm = ClientMember.new(:member_phone=>member_phone, :client_id=>client_id)
			cm.save
		end
	end
end
