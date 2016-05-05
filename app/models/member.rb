# encoding: UTF-8
class Member < ActiveRecord::Base
  attr_accessor :name,:sex,:borded_at,:pic,:address,:email, :client_id
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  Sex = { I18n.t(:male)=>:male, I18n.t(:female)=>:female}
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:client_id, :phone]

  scope :wechat_binded, ->{where(:wechat_binded=>true)}
  scope :wechat_unbinded, ->{where.not(:wechat_binded=>true)}
  scope :capcha_not_expired, ->{where(arel_table[:capcha_expired_at].lteq(DateTime.now))}

  validates :phone, :presence=>true, :uniqueness=>true
  validates_datetime :borded_at, :allow_nil=>true

  has_many :managed_clients, ->{where(:client_managers=>{:admin=>1})}, :through=>:client_managers, :source=>:client#, :foreign_key=>:admin_phone, :primary_key=>:phone
  has_many :managed_members, :class_name=>Member, :through=>:managed_clients, :source=>:members

  has_many :client_members, :foreign_key=>:phone, :primary_key=>:phone
  has_many :clients, :through=>:client_members

  has_many :client_managers, :foreign_key=>:phone, :primary_key=>:phone
  has_many :managed_shops, :through=>:client_managers, :source=>:shop

  # 用户具有发卷权限的卡卷
  has_many :sender_card_tpls, ->{where(:client_managers=>{:sender=>1}).uniq}, :through=>:managed_shops, :source=>:card_tpls

  # 用户具有核销权限的卡卷
  has_many :checker_card_tpls, ->{where(:client_managers=>{:checker=>1}).uniq}, :through=>:managed_shops, :source=>:card_tpls

  has_many :checked_cards, :class_name=>Card, :primary_key=>:phone, :foreign_key=>:checker_phone
  has_many :sended_cards, :class_name=>Card, :primary_key=>:phone, :foreign_key=>:sender_phone
  has_many :acquired_cards, :class_name=>Card, :primary_key=>:phone, :foreign_key=>:phone

  has_many :dayus, :as=>:dayuable

  def self.permit_params
    [:phone, :username, :password, :password_confirmation]
  end

  def self.client_permit_params
    [:email, :password, :password_confirmation, :name, :sex, :borded_at, :pic, :address, :email]
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    client_id = conditions.delete(:client_id)
    where(conditions.to_h).includes(:managed_clients).where(:clients=>{:id=>client_id},:client_managers=>{:admin=>true}).first
  end  

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def client_id=(client_id)    
    @client_id = client_id
  end

  def client_id
    @client_id
  end

  def username
    name
    remember_me!

    rememberable_value
  end

  def send_capcha_bind_wechat
    type = :bind_wechat

    if Dayu.allow_send(self, type) === true
      self.bind_wechat_capcha = rand(100000..999999)
      self.save

      config = {
        'type'=>type,
        'smsType'=>:normal,
        'smsFreeSignName'=>'前站',
        'smsParam'=>{code: self.bind_wechat_capcha, product: '', item: "绑定微信"},
        'recNum'=>phone,
        'smsTemplateCode'=>:SMS_2145923
      }

      dy = Dayu.createByDayuable(self, config)
      dy.run
    else
      false
    end    
  end

  def send_capcha_update_password
    type = :update_password

    if Dayu.allow_send(self, type) === true
      self.update_password_capcha = rand(100000..999999)
      self.save

      config = {
        'type'=>type,
        'smsType'=>:normal,
        'smsFreeSignName'=>'前站',
        'smsParam'=>{code: self.update_password_capcha, product: '', item: "修改密码"},
        'recNum'=>phone,
        'smsTemplateCode'=>:SMS_2145923
      }

      dy = Dayu.createByDayuable(self, config)
      dy.run
    else
      false
    end    
  end

  def send_capcha_recover_password
    type = :recover_password

    if Dayu.allow_send(self, type) === true
      self.recover_password_capcha = rand(100000..999999)
      self.save

      config = {
        'type'=>type,
        'smsType'=>:normal,
        'smsFreeSignName'=>'前站',
        'smsParam'=>{code: self.recover_password_capcha, product: '', item: "找回密码"},
        'recNum'=>phone,
        'smsTemplateCode'=>:SMS_2145923
      }

      dy = Dayu.createByDayuable(self, config)
      dy.run
    else
      false
    end
  end

  def send_capcha_validate_user
    type = :validate_user

    if Dayu.allow_send(self, type) === true
      self.capcha = rand(100000..999999)
      self.save

      config = {
        'type'=>type,
        'smsType'=>:normal,
        'smsFreeSignName'=>'前站',
        'smsParam'=>{code: self.update_password_capcha, product: '', item: "修改密码"},
        'recNum'=>phone,
        'smsTemplateCode'=>:SMS_2145923
      }

      dy = Dayu.createByDayuable(self, config)
      dy.run
    else
      false
    end    
  end

  
end
