class ClientMember < ActiveRecord::Base
	belongs_to :member
	belongs_to :client
end
