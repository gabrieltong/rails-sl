class Client < ActiveRecord::Base
	alias_attribute :service_started_at, :service_started
	alias_attribute :longitude, :location_y
	alias_attribute :latitude, :localtion_x

	attr_accessor :tags_text
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
	validates :longitude, :numericality=>{:greater_than_or_equal_to=>-180, :less_than_or_equal_to=>180}, :allow_nil=>true
	validates :latitude, :numericality=>{:greater_than_or_equal_to=>-90, :less_than_or_equal_to=>90}, :allow_nil=>true

	has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

	has_attached_file :wechat_logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :wechat_logo, content_type: /\Aimage\/.*\Z/

  belongs_to :sp, :class_name=>:Client, :foreign_key=>:sp_id
  has_many :clients, :class_name=>:Client, :foreign_key=>:sp_id
  has_many :client_members
  has_many :members, :through=>:client_members
  has_many :shops
  has_many :groups
  has_many :group_members, :through=>:members
  has_many :client_managers
  has_many :managers, :through=>:client_managers

  scope :sp, ->{where(:is_sp=>true)}

  acts_as_taggable_on :tag

  after_create do |record|
  	msg_admin_create(record.changes['phone'][1])
  end

# 修改商户管理员时， 重新发送短信
  # after_save do |record|
  # 	# record.generate_admin
  # 	if record.changes['phone']
  # 		# msg_admin_delete(record.changes['phone'][0])
  # 		msg_admin_create(record.changes['phone'][1])
  # 	end
  # end

	def self.permit_params
		[:title,:reg,:address,:position,:location_y,:localtion_x,:phone,:area,:type,:service_started,:service_ended_at,:website,:wechat_account,:wechat_title,:logo,:wechat_logo,:tags_text, :is_sp, :sp_id ,:show_name,:show_phone,:show_sex,:show_borded_at,:show_pic,:show_address,:show_email, :longitude, :latitude]
	end

	def hqhj
		"http://hongq.net/hqhj/#{id}"
	end

	def hyzx
		"http://hongq.net/hyzx/#{id}"
	end

	def tags_text= (value)
		self.tag_list = value
	end

	def tags_text
		self.tag_list.join(',')
	end

	def service_deadline
		"#{service_started}-#{service_ended_at}"
	end

  def msg_admin_create_config(phone)
		title = "#{self.title}的管理员"
		code = "123456"
		return {
	    'smsType'=>'normal',
	    'smsFreeSignName'=>'前站',
	    'smsParam'=>"{'code':'#{code}','product'=>'','item'=>'#{title}'}",
	    'recNum'=>phone,
	    'smsTemplateCode'=>'SMS_2145923'
		}
	end

	def msg_admin_delete_config(phone)
		title = "#{self.title}的管理员"
		code = "123456"
		return {
	    'smsType'=>'normal',
	    'smsFreeSignName'=>'前站',
	    'smsParam'=>"{'code':'#{code}','product'=>'','item'=>'#{title}'}",
	    'recNum'=>phone,
	    'smsTemplateCode'=>'SMS_2145923'
		}
	end

# 管理员权限添加短信
# TODO 添加对phone的验证 ， 类似  PhoneValidator.validate(phone)
	def msg_admin_create(phone)
		if phone
			dy = Dayu.createByDayuable(self, msg_admin_create_config(phone))
			result = dy.run
		end
	end

# 管理员权限取消短信
# TODO 添加对phone的验证 ， 类似  PhoneValidator.validate(phone)
	def msg_admin_delete(phone)
		if phone
			dy = Dayu.createByDayuable(self, msg_admin_delete_config(phone))
			dy.run
		end
	end

	def generate_admin
		if phone
			m = Member.find_by_phone(phone)
			if m.nil?
				m = Member.new(:phone=>phone)
				m.password = rand(100000000000)
				m.save
			end
		end
	end
end
