class ClientGroup < ActiveRecord::Base
	belongs_to :client
	has_many :client_group_members
	has_many :members, :through=>:client_group_members
end
