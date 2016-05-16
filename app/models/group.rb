class Group < ActiveRecord::Base
  belongs_to :client
  has_many :group_members
  has_many :members, :primary_key=>:phone, :foreign_key=>:phone

  validates :title, :position, :desc, :active, :presence=>true
  validates :title, :uniqueness=>{ :scope=>:client_id }

  scope :default, ->{where(:default=>true)}
  scope :active, ->{where(:active=>true)}
  scope :by_client, ->(client_id){where(:client_id=>client_id)}  
  
  def self.permit_params
    [:client_id,:title,:position,:desc,:active,:default]
  end

  def to_default
    self.default = true
    self.save :valdiate=>false
  end

  after_save do |record|
    if record.default
      record.client.groups.default.reject {|g|g.id == self.id }.each do |g|
        g.default = false
        g.save
      end
    end
  end
end
