class ChinaPhoneValidator < ActiveModel::EachValidator
	REGEX = /\A(13|15|17|18)[0-9]\d{8}\z/
	def validate_each(record, attribute, value)
    unless value.to_s.match REGEX
      record.errors[attribute] << (options[:message] || "is not an phone")
    end
  end
end