class Member < ActiveRecord::Base
	attr_accessor :name,:sex,:borded_at,:pic,:address,:email	
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:phone]

  scope :wechat_binded, ->{where(:wechat_binded=>true)}
  scope :wechat_unbinded, ->{where.not(:wechat_binded=>true)}

  validates :phone, :presence=>true, :uniqueness=>true

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

	def email_required?
    false
  end

  def email_changed?
    false
  end	
end
