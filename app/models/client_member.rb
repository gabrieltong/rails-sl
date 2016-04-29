# encoding: UTF-8
class ClientMember < ActiveRecord::Base
  belongs_to :member, :primary_key=>:phone, :foreign_key=>:phone
  belongs_to :client
  has_many :group_members, :primary_key=>:phone, :foreign_key=>:phone
  has_many :groups, :through=>:group_members
  has_many :moneys

  scope :enough_money, ->(money){where(arel_table[:money].gteq(money))}
  scope :id, ->(id){where(:id=>id)}
  scope :phone, ->(phone){where(:phone=>phone)}

  has_attached_file :pic, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :pic, content_type: /\Aimage\/.*\Z/	

  has_many :imports, :as=>:importable

# 正值表示充值 ， 负值表示花费
  def add_money money, by_phone
  	result = self.class.enough_money(-money).id(id).update_all(:money=>self.money + money) == 1 ? true : false
  	if result === true
  		moneys << Money.new(:money=>money, :client_member_id=>id, :by_phone=>by_phone)
  	end
  	result
  end

  def spend_money money, by_phone
  	add_money -money, by_phone
  end

  def charge_money money, by_phone
  	add_money money, by_phone
  end
end
