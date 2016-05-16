class ClientDecorator < Draper::Decorator
  delegate_all

  def settings
  	result = []
		result.push({
			:key=>:name,
			:i18n=>I18n.t('activerecord.attributes.client_member.name'),
			:type=>:String
		}) if self.show_name
		result.push({
			:key=>:borned_at,
			:i18n=>I18n.t('activerecord.attributes.client_member.borned_at'),
			:type=>:Date
		}) if self.show_borned_at
		result.push({
			:key=>:address,
			:i18n=>I18n.t('activerecord.attributes.client_member.address'),
			:type=>:String
		}) if self.show_address
		result.push({
			:key=>:email,
			:i18n=>I18n.t('activerecord.attributes.client_member.email'),
			:type=>:Email
		}) if self.show_email
		result.push({
			:key=>:pic,
			:i18n=>I18n.t('activerecord.attributes.client_member.pic'),
			:type=>:Image
		}) if self.show_pic
		result.push({
			:key=>:sex,
			:i18n=>I18n.t('activerecord.attributes.client_member.sex'),
			:type=>:Enum,
			:values=>Member::Sex.invert
		}) if self.show_sex
		result.push({
			:key=>:license_plate,
			:i18n=>I18n.t('activerecord.attributes.client_member.license_plate'),
			:type=>:String,
		}) if self.show_license_plate
		result.push({
			:key=>:identity,
			:i18n=>I18n.t('activerecord.attributes.client_member.identity'),
			:type=>:String,
		}) if self.show_identity
		result.push({
			:key=>:position,
			:i18n=>I18n.t('activerecord.attributes.client_member.position'),
			:type=>:String,
		}) if self.show_position
		result.push({
			:key=>:company,
			:i18n=>I18n.t('activerecord.attributes.client_member.company'),
			:type=>:String,
		}) if self.show_company
		result.push({
			:key=>:collage,
			:i18n=>I18n.t('activerecord.attributes.client_member.collage'),
			:type=>:String,
		}) if self.show_collage
		result.push({
			:key=>:emotion,
			:i18n=>I18n.t('activerecord.attributes.client_member.emotion'),
			:type=>:Enum,
			:values=>ClientMember::Emotion
		}) if self.show_emotion
		result.push({
			:key=>:car_type,
			:i18n=>I18n.t('activerecord.attributes.client_member.car_type'),
			:type=>:String,
		}) if self.show_car_type
		result.push({
			:key=>:remark,
			:i18n=>I18n.t('activerecord.attributes.client_member.remark'),
			:type=>:Text,
		}) if self.show_remark
		result
  end
end
