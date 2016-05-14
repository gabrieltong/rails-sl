class WechatUser < ActiveRecord::Base
	has_one :member, :primary_key=>:phone, :foreign_key=>:phone

	validates :openid, :presence=>true, :uniqueness=>true
	serialize :privilege, JSON
	# after_save do |record|
	# 	record.update_member_wechat_binded
	# end

	# def update_member_wechat_binded
	# 	if member
	# end
end
