class ClientDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

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
		result
  end
end
