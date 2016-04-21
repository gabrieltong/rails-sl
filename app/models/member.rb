class Member < ActiveRecord::Base
	attr_accessor :name,:sex,:borded_at,:pic,:address,:email, :client_id
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  Sex = { I18n.t(:male)=>:male, I18n.t(:female)=>:female}
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:client_id, :phone]

  scope :wechat_binded, ->{where(:wechat_binded=>true)}
  scope :wechat_unbinded, ->{where.not(:wechat_binded=>true)}

  validates :phone, :presence=>true, :uniqueness=>true
  validates_datetime :borded_at, :allow_nil=>true

  has_many :managed_clients, :class_name=>Client, :foreign_key=>:admin_phone, :primary_key=>:phone
  has_many :managed_members, :class_name=>Member, :through=>:managed_clients, :source=>:members

  has_many :client_members
  has_many :clients, :through=>:client_members

  has_many :client_managers
  has_many :managed_shops, :through=>:client_managers, :source=>:shop

	def self.permit_params
		[:phone, :username, :password, :password_confirmation]
	end

	def self.client_permit_params
		[:email, :password, :password_confirmation, :name, :sex, :borded_at, :pic, :address, :email]
	end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    client_id = conditions.delete(:client_id)
    where(conditions.to_h).includes(:managed_clients).where(:clients=>{:id=>client_id}).first
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
  end
end
