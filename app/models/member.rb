class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:phone]
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
