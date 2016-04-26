class CardTpl < ActiveRecord::Base
  attr_accessor :change_remain

  State = { I18n.t('card_tpl.state.active')=>'active', I18n.t('card_tpl.state.inactive')=>'inactive', I18n.t('card_tpl.state.paused')=>'paused'}
  UseWeeks = {I18n.t("use_weeks.monday")=>'monday', I18n.t("use_weeks.tuesday")=>'tuesday', I18n.t("use_weeks.wednesday")=>'wednesday', I18n.t("use_weeks.thursday")=>'thursday', I18n.t("use_weeks.friday")=>'friday', I18n.t("use_weeks.saturday")=>'saturday', I18n.t("use_weeks.sunday")=>'sunday'}
  UseHours = {I18n.t("check_hours.h0")=>"h0", I18n.t("check_hours.h1")=>"h1", I18n.t("check_hours.h2")=>"h2", I18n.t("check_hours.h3")=>"h3", I18n.t("check_hours.h4")=>"h4", I18n.t("check_hours.h5")=>"h5", I18n.t("check_hours.h6")=>"h6", I18n.t("check_hours.h7")=>"h7", I18n.t("check_hours.h8")=>"h8", I18n.t("check_hours.h9")=>"h9", I18n.t("check_hours.h10")=>"h10", I18n.t("check_hours.h11")=>"h11", I18n.t("check_hours.h12")=>"h12", I18n.t("check_hours.h13")=>"h13", I18n.t("check_hours.h14")=>"h14", I18n.t("check_hours.h15")=>"h15", I18n.t("check_hours.h16")=>"h16", I18n.t("check_hours.h17")=>"h17", I18n.t("check_hours.h18")=>"h18", I18n.t("check_hours.h19")=>"h19", I18n.t("check_hours.h20")=>"h20", I18n.t("check_hours.h21")=>"h21", I18n.t("check_hours.h22")=>"h22", I18n.t("check_hours.h23")=>"h23"}
  IndateType = { I18n.t('indate_type.fixed')=>'fixed', I18n.t('indate_type.dynamic')=>'dynamic'}
  Type = { I18n.t('card_tpl.type.CardATpl')=>'CardATpl', I18n.t('card_tpl.type.CardBTpl')=>'CardBTpl'}

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
  has_many :cards

  scope :ab, ->{where(:type=>[:CardATpl, :CardBTpl])}
  scope :a, ->{where(:type=>:CardATpl)}
  scope :b, ->{where(:type=>:CardBTpl)}
  scope :acquire_datetime_valid, ->{where(arel_table[:acquire_from].lt(DateTime.now)).where(arel_table[:acquire_to].gt(DateTime.now))}

  serialize :acquire_weeks
  serialize :check_weeks
  serialize :check_hours

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

  state_machine :state, :initial => :inactive do
    event :activate do
      transition [:inactive, :paused] => :active
    end

    event :deactivate do
      transition [:active, :paused] => :inactive
    end

    event :pause do
      transition [:active, :inactive] => :paused
    end

    state :inactive do
      def can_check?
        :card_tpl_inactive
      end

      def can_acquire?(phone)
        :card_tpl_inactive
      end
    end

    state :active do
      def can_check?
        _can_check?
      end

      
      # card_tpl.remain
      # card_tpl.acquire.from acquire.to
      # card_tpl.week
      # card_tpl.hour
      # person_limit
      # period.person_limit
      # card_tpl.state
      # 判断某手机号能否领优惠卷
      def can_acquire? phone
        if cards.not_acquired.empty?
          :no_valid_card
        elsif date_can_acquire? != true
          :date_invalid
        elsif weekday_can_acquire? != true
          :weekday_invalid
        elsif hour_can_acquire? != true
          :hour_invalid
        elsif phone_can_acquire?(phone) != true
          :person_limit_overflow
        elsif period_phone_can_acquire?(phone)!= true
          :period_person_limit_overflow
        else
          true
        end
      end
    end

    state :paused do
      def can_check?
        _can_check?
      end

      def can_acquire?(phone)
        :card_tpl_paused
      end
    end
  end


  before_validation do |record|
    if record.change_remain and record.change_remain.to_i != 0
      quantities.build(:number=>change_remain)
    end
  end

  # 验证用户
  def period_phone_can_acquire? phone
    if period = period_now
      acquired_time_gt = Card.arel_table[:acquired_time].gt(period.from.strftime("%H:%M"))
      acquired_time_lt = Card.arel_table[:acquired_time].lt(period.to.strftime("%H:%M"))
      
      cards.where(:phone=>phone).where(acquired_time_gt).where(acquired_time_lt).size < period.person_limit
    end
  end

  # 验证用户
  def phone_can_acquire? phone
    cards.where(:phone=>phone).size < person_limit
  end

  # 验证投放日期日期
  def date_can_acquire?
    self.class.acquire_datetime_valid.exists?(id)
  end

  # 验证投放时间
  def hour_can_acquire?
    !period_now.nil?
  end

  def period_now
    now = DateTime.now
    time = "#{now.hour}:#{now.minute}"
    where_from = Period.arel_table[:from].lt(time)
    where_to = Period.arel_table[:to].gt(time)
    periods.where(where_from).where(where_to).first
  end
  # 验证投放星期
  def weekday_can_acquire?
    now = DateTime.now
    acquire_weeks.reject(&:empty?).each do |week|
      method = "#{week}?"
      if now.respond_to?(method) and now.send(method) == true
        return true
      end
    end
    false
  end

  # 验证核销时间
  def hour_can_check?
    now = DateTime.now
    check_hours.reject(&:empty?).each do |hour|
      if now.hour == hour.gsub('h','').to_i
        return true
      end
    end
    false
  end

  # 验证核销星期
  def weekday_can_check?
    now = DateTime.now
    check_weeks.reject(&:empty?).each do |week|
      method = "#{week}?"
      if now.respond_to?(method) and now.send(method) == true
        return true
      end
    end
    false
  end

  def self.generate_hours
    h = {}
    1.upto(24) do |i|
    h["#{i-1}点~#{i}点"] = "#{i-1}-#{i}"
    end
    h
  end

  def cover_url
    if cover.blank?
      ''
    else
      cover.url(:medium)
    end
  end

  def share_cover_url
    if share_cover.blank?
      ''
    else
      share_cover.url(:medium)
    end
  end

  def guide_cover_url
    if guide_cover.blank?
      ''
    else
      guide_cover.url(:medium)
    end
  end

  def acquire(phone, by_member, number=1)
    can_acquire = can_acquire?(phone)
    if can_acquire === true
      can_send_by_member = self.class.can_send_by_member?(id, by_member)
      if can_send_by_member === true
        result = cards.not_acquired.limit(number).update_all(:phone=>phone, :acquired_at=>DateTime.now, :acquired_time=>DateTime.now.strftime("%H:%M"), :sender_phone=>by_member.phone)
        return result
      else
        return can_send_by_member
      end
    else
      return can_acquire
    end
  end

  def self.can_acquire? id, phone
    record = find_by_id(id)
    if record
      record.can_acquire? phone
    else
      :no_record
    end
  end

  # 判断卡卷是否能被member投放
  def self.can_send_by_member? id, member
    member.sender_card_tpls.exists? id
  end

  # 判断卡卷是否能被member投放
  def self.can_check_by_member? id, member
    member.checker_card_tpls.exists? id
  end

  def self.acquire(id, phone, by_member, number=1)
    record = find_by_id(id)
    if record
      record.acquire(phone, by_member, number)
    else
      :no_record
    end
  end

  private

  def self.inheritance_column
    'type'
  end 

  def self.default_scope
    where type: [:CardBTpl,:CardATpl]
  end
  # 卡卷是否可核销
  def _can_check?
    if weekday_can_check? != true
      return :weekday_cannot_check
    elsif hour_can_check? != true
      return :hour_cannot_check
    else
      return true
    end
  end
end
