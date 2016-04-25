class Card < ActiveRecord::Base
  acts_as_paranoid
  # uniquify :code, :salt, :length => 12, :chars => 0..9
  belongs_to :card_tpl
  belongs_to :member, :foreign_key=>:phone, :primary_key=>:phone
  belongs_to :added_quantity, :class_name=>Quantity, :foreign_key=>:added_quantity_id
  belongs_to :removed_quantity, :class_name=>Quantity, :foreign_key=>:removed_quantity_id
  belongs_to :client

  scope :acquired, ->{where.not(:acquired_at=>nil)}
  scope :checked, ->{where.not(:checked_at=>nil)}

  scope :not_acquired, ->{where(:acquired_at=>nil)}
  scope :not_checked, ->{where(:checked_at=>nil)}


  validates :card_tpl_id, :code, :added_quantity_id, :presence=>true
  validates :code, :uniqueness=>true
  # validates :type, :inclusion => %w(CardA CardB)
  validates :removed_quantity_id, :presence => true, :if=>'!deleted_at.nil?'
  validates :phone, :presence => true, :if=>'!acquired_at.nil?'

  before_validation do |record|
    if code.blank?
      record.generate_code
    end
  end

  before_create do |record|
    if code.blank?
      record.generate_code
    end
    record.generate_type
  end

  # def self.default_scope
  #   where type: [:CardB,:CardA]
  # end

  def self.inheritance_column
    'type'
  end

  def generate_code
    self.code = loop do
      random_code = rand(100000000000...999999999999)
      break random_code unless self.class.exists?(code: random_code)
    end
  end

  def generate_type
    if card_tpl.is_a? CardATpl
      self.type = :CardA
    end

    if card_tpl.is_a? CardBTpl
      self.type = :CardB
    end
  end

  def self.generate_depot(number = 10**6)
    number.times do
      card = Card.new
      card.save :validate=>false  
    end
  end
end
