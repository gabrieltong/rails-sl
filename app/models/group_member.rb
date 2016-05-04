class GroupMember < ActiveRecord::Base
  belongs_to :group
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
  end

  def generate_client_member
    if client_member.nil? and client_id and phone
      cm = ClientMember.new(:phone=>phone, :client_id=>client_id)
      cm.save
    end
  end
end
