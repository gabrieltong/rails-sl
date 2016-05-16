# encoding: UTF-8
class Member < ActiveRecord::Base
  attr_accessor :name,:sex,:borded_at,:pic,:address,:email, :client_id
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  Sex = { I18n.t(:male)=>:male, I18n.t(:female)=>:female}
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:client_id, :phone]

  scope :wechat_binded, ->{joins(:wechat_user).where.not(WechatUser.arel_table['openid'].eq(nil))}
  # scope :wechat_unbinded, ->{joins(:wechat_user).where.not(WechatUser.where("wechat_users.phone = members.phone").limit(1).arel.exists)}

  scope :capcha_not_expired, ->{where(arel_table[:capcha_expired_at].lteq(DateTime.now))}

  delegate :openid, :to=>:wechat_user, :allow_nil=>true

  validates :phone, :presence=>true, :uniqueness=>true, :china_phone=>true

  validates_datetime :borded_at, :allow_nil=>true

  has_many :managed_clients, ->{where(:client_managers=>{:admin=>1})}, :through=>:client_managers, :source=>:client#, :foreign_key=>:admin_phone, :primary_key=>:phone
  has_many :managed_members, :class_name=>Member, :through=>:managed_clients, :source=>:members

  has_many :client_members, :foreign_key=>:phone, :primary_key=>:phone
  has_many :clients, :through=>:client_members

  has_many :group_members, :foreign_key=>:phone, :primary_key=>:phone
  has_many :groups, :through=>:group_members

  has_many :client_managers, :foreign_key=>:phone, :primary_key=>:phone
  has_many :managed_shops, :through=>:client_managers, :source=>:shop

  # 用户具有发卷权限的卡卷
  has_many :sender_card_tpls, ->{where(:client_managers=>{:sender=>1}).uniq}, :through=>:managed_shops, :source=>:card_tpls

  # 用户具有核销权限的卡卷
  has_many :checker_card_tpls, ->{where(:client_managers=>{:checker=>1}).uniq}, :through=>:managed_shops, :source=>:card_tpls

  
  # 用户可以核销的卡密
  has_many :active_cards, ->{where(Card.arel_table[:from].lt(DateTime.now)).where(Card.arel_table[:to].gt(DateTime.now))}, :class_name=>Card, :primary_key=>:phone, :foreign_key=>:phone
  # 用户被核销的卡密
  has_many :checked_cards, :class_name=>Card, :primary_key=>:phone, :foreign_key=>:checker_phone
  # 用户得到的卡密
  has_many :acquired_cards, :class_name=>Card, :primary_key=>:phone, :foreign_key=>:phone
  # 用户发送的卡密
  has_many :sended_cards, :class_name=>Card, :primary_key=>:phone, :foreign_key=>:sender_phone
  # 用户得到的卡卷， 通过卡密搜索
  has_many :acquired_card_tpls, -> {uniq}, :through=>:acquired_cards, :source=>:card_tpl
  # 用户已核销的卡卷， 通过卡密搜索
  has_many :checked_card_tpls, -> {uniq}, :through=>:checked_cards, :source=>:card_tpl
  # 用户可以核销的卡卷
  has_many :active_card_tpls, -> {uniq}, :through=>:active_cards, :source=>:card_tpl

  has_many :dayus, :as=>:dayuable

  has_many :moneys, :through=>:client_members
  has_one :wechat_user, :primary_key=>:phone, :foreign_key=>:phone

  after_create do |member|
    member.remember_me!
  end

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
    rememberable_value
  end
end
