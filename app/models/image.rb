class Image < ActiveRecord::Base
  belongs_to :imageable, :polymorphic=>true
  belongs_to :member, :foreign_key=>:phone, :primary_key=>:phone
  belongs_to :client

  validates :member, :presence=>true
  validates :file, :presence=>true

  delegate :url, :to=>:file, :prefix=>true
  # validates :imageable, :presence=>true

  has_attached_file :file, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/
end
