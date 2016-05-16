class ClientMemberDecorator < Draper::Decorator
  delegate_all

  delegate :name, :to=>:object, :prefix=>true
  delegate :sex, :to=>:object, :prefix=>true
  delegate :borded_at, :to=>:object, :prefix=>true
  delegate :pic, :to=>:object, :prefix=>true
  delegate :address, :to=>:object, :prefix=>true
  delegate :email, :to=>:object, :prefix=>true
  delegate :license_plate, :to=>:object, :prefix=>true
  delegate :identity, :to=>:object, :prefix=>true
  delegate :position, :to=>:object, :prefix=>true
  delegate :company, :to=>:object, :prefix=>true
  delegate :collage, :to=>:object, :prefix=>true
  delegate :emotion, :to=>:object, :prefix=>true
  delegate :car_type, :to=>:object, :prefix=>true
  delegate :remark, :to=>:object, :prefix=>true

  alias_method :html_name, :object_name
  alias_method :html_sex, :object_sex
  alias_method :html_borded_at, :object_borded_at
  alias_method :html_pic, :object_pic
  alias_method :html_address, :object_address
  alias_method :html_email, :object_email
  alias_method :html_license_plate, :object_license_plate
  alias_method :html_identity, :object_identity
  alias_method :html_position, :object_position
  alias_method :html_company, :object_company
  alias_method :html_collage, :object_collage
  alias_method :html_emotion, :object_emotion
  alias_method :html_car_type, :object_car_type
  alias_method :html_remark, :object_remark

	def html_pic
		ActionController::Base.helpers.image_tag(pic.url(:thumb)).html_safe
	end
end
