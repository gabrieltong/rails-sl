# encoding: UTF-8
class ClientMember < ActiveRecord::Base
  belongs_to :member, :primary_key=>:phone, :foreign_key=>:phone
  belongs_to :client
  has_many :group_members, :primary_key=>:phone, :foreign_key=>:phone
  has_many :groups, :through=>:group_members
  has_many :moneys
  has_many :acquired_cards, ->(i){where("client_id = ?", i.client_id)}, :class_name=>Card, :primary_key=>:phone, :foreign_key=>:phone
  has_many :imports, :as=>:importable

  validates :client_id, :phone, :presence=>true

  scope :enough_money, ->(money){where(arel_table[:money].gteq(money))}
  scope :id, ->(id){where(:id=>id)}
  scope :by_id, ->(id){where(:id=>id)}
  scope :phone, ->(phone){where(:phone=>phone)}
  scope :by_phone, ->(phone){where(:phone=>phone)}

  has_attached_file :pic, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :pic, content_type: /\Aimage\/.*\Z/	


  delegate :wechatid, to: :client, :allow_nil=>true

# 正值表示充值 ， 负值表示花费
  def add_money money, by_phone
  	result = self.class.enough_money(-money).id(id).update_all(:money=>self.money + money) == 1 ? true : false
  	if result === true
  		moneys << Money.new(:money=>money, :client_member_id=>id, :by_phone=>by_phone, :client_id=>client_id, :phone=>phone)
  	end
  	result
  end

  def spend_money money, by_phone
  	result = add_money -money, by_phone
    if result === true
      client.create_activity key: 'member.spend_money', owner: Member.find_by_phone(by_phone),recipient: self,  :parameters=>{:phone=>phone, :by_phone=>by_phone, :money=>money,:type=>'消费',:msg=>"#{phone}消费#{money},操作员#{by_phone}"}
    end
    result
  end

  def charge_money money, by_phone
  	result = add_money money, by_phone
    if result === true
      client.create_activity key: 'member.charge_money', owner: Member.find_by_phone(by_phone),recipient: self,  :parameters=>{:phone=>phone, :by_phone=>by_phone, :money=>money,:type=>'充值',:msg=>"#{phone}充值#{money},操作员#{by_phone}"}
    end
    result
  end
end
