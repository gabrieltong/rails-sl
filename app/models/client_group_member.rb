class ClientGroupMember < ActiveRecord::Base
	belongs_to :client_group
	belongs_to :member
end
