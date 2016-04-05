class Client < ActiveRecord::Base
	validates :title, presence: true
	# validates :reg, :presence=>true
	# validates :address, :presence=>true
	# validates :position, :presence=>true
	# validates :location_y, :presence=>true
	# validates :localtion_x, :presence=>true
	# validates :phone, :presence=>true
	# validates :area, :presence=>true
	# validates :type, :presence=>true
	# validates :service_started, :presence=>true
	# validates :service_ended_at, :presence=>true
	# validates :website, :presence=>true
	# validates :wechat_account, :presence=>true
	# validates :wechat_title, :presence=>true
	alias_attribute :service_started_at, :service_started

	def self.permit_params
		[:title,:reg,:address,:position,:location_y,:localtion_x,:phone,:area,:type,:service_started,:service_ended_at,:website,:wechat_account,:wechat_title]
	end


end
