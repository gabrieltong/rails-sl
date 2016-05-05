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
    return {
      'type'=>'assigned_admin',
      'smsType'=>'normal',
      'smsFreeSignName'=>'红券',
      'smsParam'=>{product: client.title},
      'recNum'=>phone,
      'smsTemplateCode'=>'SMS_7816310'
    }
  end

  def msg_admin_delete_config
    return {
      'type'=>'remove_admin',
      'smsType'=>'normal',
      'smsFreeSignName'=>'前站',
      'smsParam'=>{product: capcha.code.to_s},
      'recNum'=>phone,
      'smsTemplateCode'=>'SMS_2145923'
    }
  end

# 管理员权限添加短信
# TODO 添加对admin_phone的验证 ， 类似  PhoneValidator.validate(admin_phone)
  def msg_admin_create
    config = msg_admin_create_config
    dy = Dayu.createByDayuable(self, config)
    dy.run
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
