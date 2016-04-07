class GroupMember < ActiveRecord::Base
	belongs_to :group
	belongs_to :member
	
	validates :group_id, :member_id, :started_at, :eneded_at, :presence=>true
end
