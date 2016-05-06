class GroupMember < ActiveRecord::Base
  belongs_to :group
  belongs_to :client
  belongs_to :member, :primary_key=>:phone, :foreign_key=>:phone
  belongs_to :client_member, ->(gm){where("client_id = ?", gm.client_id)}, :primary_key=>:phone, :foreign_key=>:phone
  validates :client_id, :group_id, :phone, :started_at, :ended_at, :presence=>true

  # client_member delegate
  delegate :name, :to=>:client_member, :allow_nil=>true
  delegate :sex, :to=>:client_member, :allow_nil=>true
  delegate :borned_at, :to=>:client_member, :allow_nil=>true
  delegate :address, :to=>:client_member, :allow_nil=>true
  delegate :email, :to=>:client_member, :allow_nil=>true
  delegate :pic, :to=>:client_member, :allow_nil=>true
  delegate :money, :to=>:client_member, :allow_nil=>true

  # group delegate
  delegate :title, :to=>:group, :allow_nil=>true, :prefix=>true

  scope :by_client, ->(client_id){where(:client_id=>client_id)}
  scope :phone, ->(a){where(:phone=>a)}
  scope :by_phone, ->(a){where(:phone=>a)}

  before_validation do |gm|
    gm.client_id = gm.group.client_id if gm.group
  end

  after_create do |gm|
    gm.generate_client_member
    gm.send_message_joined_group
  end

  def generate_client_member
    if client_member.nil? and client_id and phone
      cm = ClientMember.new(:phone=>phone, :client_id=>client_id)
      cm.save
    end
  end

  def send_message_joined_group
    config = {
      'type'=>__callee__,
      'smsType'=>'normal',
      'smsFreeSignName'=>'红券',
      'smsParam'=>{brand: client.try(:brand), vipgroup: group.title.to_s, wechatid: client.try(:wechat_account)},
      'recNum'=>phone,
      'smsTemplateCode'=>'SMS_8540626'
    }
    Dayu.createByDayuable(Member.first, config).run
  end

  def send_message_will_expire
    config = {
      'type'=>__callee__,
      'smsType'=>'normal',
      'smsFreeSignName'=>'红券',
      'smsParam'=>{brand: client.try(:brand), vipgroup: group.title.to_s, wechatid: client.try(:wechat_account)},
      'recNum'=>phone,
      'smsTemplateCode'=>'SMS_8480701'
    }
    Dayu.createByDayuable(Member.first, config).run
  end
end
