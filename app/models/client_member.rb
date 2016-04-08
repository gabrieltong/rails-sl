class ClientMember < ActiveRecord::Base
	belongs_to :member, :primary_key=>:phone, :foreign_key=>:phone
	belongs_to :client

	has_attached_file :pic, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :pic, content_type: /\Aimage\/.*\Z/	
end
