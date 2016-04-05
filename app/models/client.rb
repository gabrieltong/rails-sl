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

	has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

	has_attached_file :wechat_logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :wechat_logo, content_type: /\Aimage\/.*\Z/  

  acts_as_taggable_on :tag

	def self.permit_params
		[:title,:reg,:address,:position,:location_y,:localtion_x,:phone,:area,:type,:service_started,:service_ended_at,:website,:wechat_account,:wechat_title,:logo,:wechat_logo,:tags]
	end

	def hqhj
		"http://hongq.net/hqhj/#{id}"
	end

	def hyzx
		"http://hongq.net/hyzx/#{id}"
	end

	def tags= (value)
		self.tag_list = value
	end

	def tag
		self.tag_list.joins(',')
	end
end
