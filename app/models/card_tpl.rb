class CardTpl < ActiveRecord::Base
  attr_accessor :change_remain, :_from
  UseWeeks = {I18n.t("use_weeks.mon")=>'mon', I18n.t("use_weeks.thu")=>'thu', I18n.t("use_weeks.wed")=>'wed', I18n.t("use_weeks.thr")=>'thr', I18n.t("use_weeks.fri")=>'fri', I18n.t("use_weeks.sta")=>'sta', I18n.t("use_weeks.sun")=>'sun'}
  UseHours = {I18n.t("use_hours.h1")=>"h1", I18n.t("use_hours.h2")=>"h2", I18n.t("use_hours.h3")=>"h3", I18n.t("use_hours.h4")=>"h4", I18n.t("use_hours.h5")=>"h5", I18n.t("use_hours.h6")=>"h6", I18n.t("use_hours.h7")=>"h7", I18n.t("use_hours.h8")=>"h8", I18n.t("use_hours.h9")=>"h9", I18n.t("use_hours.h10")=>"h10", I18n.t("use_hours.h11")=>"h11", I18n.t("use_hours.h12")=>"h12", I18n.t("use_hours.h13")=>"h13", I18n.t("use_hours.h14")=>"h14", I18n.t("use_hours.h15")=>"h15", I18n.t("use_hours.h16")=>"h16", I18n.t("use_hours.h17")=>"h17", I18n.t("use_hours.h18")=>"h18", I18n.t("use_hours.h19")=>"h19", I18n.t("use_hours.h20")=>"h20", I18n.t("use_hours.h21")=>"h21", I18n.t("use_hours.h22")=>"h22", I18n.t("use_hours.h23")=>"h23", I18n.t("use_hours.h24")=>"h24"}
  IndateType = { I18n.t('indate_type.fixed')=>'fixed', I18n.t('indate_type.dynamic')=>'dynamic'}

  belongs_to :client
  belongs_to :member

  has_many :card_tpl_shops
  has_many :shops, :through=>:card_tpl_shops

  has_many :card_tpl_groups
  has_many :groups, :through=>:card_tpl_groups

  has_one :card_tpl_setting
  has_many :periods
  has_many :quantities
  has_many :images, :as=>:imageable
  has_many :draw_awards

  scope :ab, ->{where(:type=>[:CardATpl, :CardBTpl])}
  scope :a, ->{where(:type=>:CardATpl)}
  scope :b, ->{where(:type=>:CardBTpl)}

  serialize :acquire_use_weeks
  serialize :check_use_weeks
  serialize :use_hours

  accepts_nested_attributes_for :images, :allow_destroy => true
  accepts_nested_attributes_for :periods, :allow_destroy => true
  accepts_nested_attributes_for :groups, :allow_destroy => true
  accepts_nested_attributes_for :quantities, :allow_destroy => false



  validates :client_id, :title, :presence=>true
  validates :person_limit, :numericality => {:greater_than => 0}
  validates :total, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0}
  validates :remain, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0}
  validates :change_remain, :numericality => {:only_integer => true, :greater_than_or_equal_to => Proc.new {|i| 0 - i.remain } }, :allow_blank=>true
  validates_datetime :acquire_from, :before=>:acquire_to, :allow_blank=>true
  validates_datetime :acquire_to, :after=>:acquire_from, :allow_blank=>true

  has_attached_file :cover, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\Z/

  has_attached_file :share_cover, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :share_cover, content_type: /\Aimage\/.*\Z/

  has_attached_file :guide_cover, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :guide_cover, content_type: /\Aimage\/.*\Z/

  # before_save do |record|
  #   record.use_weeks = self::UseWeeks.select do |k,v| 
  #   record.use_weeks_zh.include? k
  #   end.values
  # end

  before_validation do |record|
    if record.change_remain and record.change_remain.to_i != 0
      quantities.build(:number=>change_remain)
    end
  end

  def self.generate_hours
    h = {}
    1.upto(24) do |i|
    h["#{i-1}点~#{i}点"] = "#{i-1}-#{i}"
    end
    h
  end

  private

  def self.inheritance_column
    'type'
  end 

  def self.default_scope
    where type: [:CardBTpl,:CardATpl]
  end  
end
