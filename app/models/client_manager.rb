class ClientManager < ActiveRecord::Base
  belongs_to :client
  belongs_to :shop
  belongs_to :manager, :class_name=>:Member, :foreign_key=>:phone, :primary_key=>:phone

  scope :admin, ->{where(:admin=>true)}
  scope :sender, ->{where(:sender=>true)}
  scope :checker, ->{where(:checker=>true)}

  validates :phone, :name, :client_id, :shop_id, :presence=>true

  def self.permit_params
    [:phone, :name, :shop_id, :admin, :checker, :sender]
  end
end
