# encoding: UTF-8
class MobileFile < ActiveRecord::Base
  acts_as_paranoid
  has_attached_file :file

  do_not_validate_attachment_file_type :file

  belongs_to :mobile_fileable,:polymorphic=>true

  validates :file,:presence => true

  def as_json(options={})
    super({
      :methods=>[:file_url],
      :only=>[:id,:file_file_name]
    }.merge options)
  end

  def file_url
    if file_file_name
      file.url.split('?')[0]
    else
      ''
    end
  end
end
