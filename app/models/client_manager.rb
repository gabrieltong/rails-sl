class ClientManager < ActiveRecord::Base
  belongs_to :client
  belongs_to :shop
  belongs_to :manager, :class_name=>:Member, :foreign_key=>:phone, :primary_key=>:phone
  has_many :dayus, :as=>:dayuable

  scope :admin, ->{where(:admin=>true)}
  scope :sender, ->{where(:sender=>true)}
  scope :checker, ->{where(:checker=>true)}

  validates :phone, :name, :client_id, :presence=>true
  validates :shop_id, :presence=>true, :if=>'admin != true' 

  after_create do |record|
    record.msg_admin_create
  end

  def self.permit_params
    [:phone, :name, :shop_id, :admin, :checker, :sender]
  end

  def msg_admin_create_config
    title = "#{self.client.title}的管理员"
    code = "123456"
    return {
      'smsType'=>'normal',
      'smsFreeSignName'=>'前站',
      'smsParam'=>{code: code, product: '', item: title},
      'recNum'=>phone,
      'smsTemplateCode'=>'SMS_2145923'
    }
  end

  def msg_admin_delete_config(admin_phone)
    title = "#{self.title}的管理员"
    code = "123456"
    return {
      'smsType'=>'normal',
      'smsFreeSignName'=>'前站',
      'smsParam'=>"{'code':'#{code}','product'=>'','item'=>'#{title}'}",
      'recNum'=>admin_phone,
      'smsTemplateCode'=>'SMS_2145923'
    }
  end

# 管理员权限添加短信
# TODO 添加对admin_phone的验证 ， 类似  PhoneValidator.validate(admin_phone)
  def msg_admin_create
    if self.class.admin.exists?(self.id) and Dayu.allow_send(self) === true
      dy = Dayu.createByDayuable(self, msg_admin_create_config)
      dy.run
    end
  end

# 管理员权限取消短信
# TODO 添加对admin_phone的验证 ， 类似  PhoneValidator.validate(admin_phone)
  def msg_admin_delete(admin_phone)
    if admin_phone
      dy = Dayu.createByDayuable(self, msg_admin_delete_config(admin_phone))
      dy.run
    end
  end  
end
