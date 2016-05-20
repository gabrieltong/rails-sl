class ManagerShop < ActiveRecord::Base
	belongs_to :client_manager
	belongs_to :shop
end
