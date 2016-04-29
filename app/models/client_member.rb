# encoding: UTF-8
class ClientMember < ActiveRecord::Base
  belongs_to :member, :primary_key=>:phone, :foreign_key=>:member_phone
  belongs_to :client
  has_many :group_members, :primary_key=>:member_phone, :foreign_key=>:member_phone
  has_many :groups, :through=>:group_members
  has_many :moneys

  scope :enough_money, ->(money){where(arel_table[:money].gteq(money))}
  scope :id, ->(id){where(:id=>id)}

  has_attached_file :pic, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :pic, content_type: /\Aimage\/.*\Z/	

  has_many :imports, :as=>:importable


# 正值表示充值 ， 负值表示花费
  def add_money money, by_member_id
  	result = self.class.enough_money(-money).id(id).update_all(:money=>self.money + money) == 1 ? true : false
  	if result === true
  		moneys << Money.new(:money=>money, :client_member_id=>id, :by_member_id=>by_member_id)
  	end
  	result
  end

  def spend_money money, by_member_id
  	add_money -money, by_member_id
  end

  def charge_money money, by_member_id
  	add_money money, by_member_id
  end
end
