class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:phone]

  has_many :managed_clients, :class_name=>Client, :foreign_key=>:admin_phone, :primary_key=>:phone
  has_many :managed_members, :class_name=>Member, :through=>:managed_clients, :source=>:members

	def self.permit_params
		[:phone, :username, :password, :password_confirmation]
	end        

	def email_required?
    false
  end

  def email_changed?
    false
  end	
end
