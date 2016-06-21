# encoding: UTF-8
class CardTpl < ActiveRecord::Base
  attr_accessor :change_remain
  attr_accessor :member_cards_count

  State = { I18n.t('card_tpl.state.active')=>'active', I18n.t('card_tpl.state.inactive')=>'inactive', I18n.t('card_tpl.state.paused')=>'paused'}
  UseWeeks = {I18n.t("use_weeks.monday")=>'monday', I18n.t("use_weeks.tuesday")=>'tuesday', I18n.t("use_weeks.wednesday")=>'wednesday', I18n.t("use_weeks.thursday")=>'thursday', I18n.t("use_weeks.friday")=>'friday', I18n.t("use_weeks.saturday")=>'saturday', I18n.t("use_weeks.sunday")=>'sunday'}
  UseHours = {I18n.t("check_hours.h0")=>"h0", I18n.t("check_hours.h1")=>"h1", I18n.t("check_hours.h2")=>"h2", I18n.t("check_hours.h3")=>"h3", I18n.t("check_hours.h4")=>"h4", I18n.t("check_hours.h5")=>"h5", I18n.t("check_hours.h6")=>"h6", I18n.t("check_hours.h7")=>"h7", I18n.t("check_hours.h8")=>"h8", I18n.t("check_hours.h9")=>"h9", I18n.t("check_hours.h10")=>"h10", I18n.t("check_hours.h11")=>"h11", I18n.t("check_hours.h12")=>"h12", I18n.t("check_hours.h13")=>"h13", I18n.t("check_hours.h14")=>"h14", I18n.t("check_hours.h15")=>"h15", I18n.t("check_hours.h16")=>"h16", I18n.t("check_hours.h17")=>"h17", I18n.t("check_hours.h18")=>"h18", I18n.t("check_hours.h19")=>"h19", I18n.t("check_hours.h20")=>"h20", I18n.t("check_hours.h21")=>"h21", I18n.t("check_hours.h22")=>"h22", I18n.t("check_hours.h23")=>"h23"}
  IndateType = { I18n.t('indate_type.fixed')=>'fixed', I18n.t('indate_type.dynamic')=>'dynamic'}
  Type = { I18n.t('card_tpl.type.CardATpl')=>'CardATpl', I18n.t('card_tpl.type.CardBTpl')=>'CardBTpl'}
  AcquireType = { I18n.t('card_tpl.acquire_type.anonymous')=>'anonymous', I18n.t('card_tpl.acquire_type.login')=>'login'}

  belongs_to :client
  belongs_to :member

  has_many :card_tpl_shops
  has_many :shops, :through=>:card_tpl_shops

  has_many :card_tpl_groups
  has_many :groups, :through=>:card_tpl_groups
  has_many :members, :through=>:groups, :source=>:members

  has_one :setting, :class_name=>CardTplSetting
  has_many :periods
  has_many :quantities
  has_many :images, :as=>:imageable
  has_many :draw_awards
  has_many :cards
  has_many :locked_cards, :through=>:cards, :source=>:locked_card

  scope :by_client, ->(client_id){where(:client_id=>client_id)}
  scope :ab, ->{where(:type=>[:CardATpl, :CardBTpl])}
  scope :a, ->{where(:type=>:CardATpl)}
  scope :b, ->{where(:type=>:CardBTpl)}

  scope :open, ->{where(:public=>true)}
  scope :unopen, ->{where.not(:public=>true)}

  scope :fixed, ->{where(:indate_type=>:fixed)}
  scope :dynamic, ->{where(:indate_type=>:dynamic)}

  scope :anonymous, ->{where(:acquire_type=>:anonymous)}
  scope :login, ->{where(:acquire_type=>:login)}

  scope :datetime_acquirable, ->{where(arel_table[:acquire_from].lt(DateTime.now)).where(arel_table[:acquire_to].gt(DateTime.now))}
  scope :week_acquirable, ->{joins(:setting).where(:card_tpl_settings=>{"acquire_#{DateTime.now.strftime('%A').downcase}"=>1})}
  scope :hour_acquirable, ->{joins(:periods).where(Period.arel_table['from'].lt("#{DateTime.now.hour}:#{DateTime.now.min}")).where(Period.arel_table['to'].gt("#{DateTime.now.hour}:#{DateTime.now.min}"))}

  scope :week_checkable, ->{joins(:setting).where(:card_tpl_settings=>{"check_#{DateTime.now.strftime('%A').downcase}"=>1})}
  scope :hour_checkable, ->{joins(:setting).where(:card_tpl_settings=>{"check_h#{DateTime.now.hour}"=>1})}

  scope :sendable_by, ->(phone){joins(:shops=>[:managers]).where.not(:public=>true).where(Member.arel_table[:phone].eq(phone)).where(ClientManager.arel_table[:sender].eq(1).or(ClientManager.arel_table[:admin].eq(1)))}
  scope :checkable_by, ->(phone){joins(:shops=>[:managers]).where(Member.arel_table[:phone].eq(phone)).where(ClientManager.arel_table[:checker].eq(1).or(ClientManager.arel_table[:admin].eq(1)))}

  serialize :acquire_weeks
  serialize :check_weeks
  serialize :check_hours

  accepts_nested_attributes_for :images, :allow_destroy => true
  accepts_nested_attributes_for :periods, :allow_destroy => true
  accepts_nested_attributes_for :groups, :allow_destroy => true
  accepts_nested_attributes_for :quantities, :allow_destroy => false

  validates :groups, :presence=> true
  validates :desc, :intro, :cover, :share_cover, :presence=> true
  validates :client_id, :title, :presence=>true
  validates :person_limit, :numericality => {:greater_than => 0}
  validates :total, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0}
  validates :remain, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0}
  validates :change_remain, :numericality => {:only_integer => true, :greater_than_or_equal_to => Proc.new {|i| 0 - i.remain } }, :allow_blank=>true
  validates :acquire_type, :inclusion=>{:in=>AcquireType.values}
  
  validates_datetime :acquire_from, :before=>:acquire_to, :allow_blank=>true
  validates_datetime :acquire_to, :after=>:acquire_from, :allow_blank=>true

  has_attached_file :cover, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\Z/

  has_attached_file :share_cover, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :share_cover, content_type: /\Aimage\/.*\Z/

  has_attached_file :guide_cover, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :guide_cover, content_type: /\Aimage\/.*\Z/

  after_initialize do |record|
    if record.new_record?
      record.acquire_weeks = UseWeeks.values
      record.check_weeks = UseWeeks.values
      record.check_hours = UseHours.values
      record.public = true
      record.groups = client.groups if client
    end
  end 

  after_save do |record|
    update_setting
  end

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

      def can_acquire? phone=nil, agent=:admin
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
      # 判断某手机号能否领优惠券
      def can_acquire? phone=nil, agent=:admin
        logger.info "#{__callee__} >>>>"
        if cards.acquirable.empty?
          I18n.t('can_acquire_error.no_acquirable_card')
        elsif public_type_can_acquire?(agent) == false
          I18n.t('can_acquire_error.public_type_not_acquirable')
        elsif acquire_type_can_acquire?(phone) == false
          I18n.t('can_acquire_error.acquire_type_not_acquirable')          
        elsif datetime_can_acquire? == false
          I18n.t('can_acquire_error.datetime_not_acquirable')
        elsif week_can_acquire? == false
          I18n.t('can_acquire_error.week_not_acquirable')
        elsif hour_can_acquire? == false
          I18n.t('can_acquire_error.hour_not_acquirable')
        elsif groups_can_acquire?(phone) == false
          I18n.t('can_acquire_error.groups_not_acquirable')
        elsif period_card_can_acquire? == false
          I18n.t('can_acquire_error.period_card_limit_overflow')
        elsif phone_can_acquire?(phone) == false
          I18n.t('can_acquire_error.phone_limit_overflow')
        elsif period_phone_can_acquire?(phone)== false
          I18n.t('can_acquire_error.period_phone_limit_overflow')
        else
          true
        end
      end
    end

    state :paused do
      def can_check?
        _can_check? number
      end

      def can_acquire? phone=nil, agent=:admin
        :card_tpl_paused
      end
    end
  end


  before_validation do |record|
    # 根据change_remain创建Quantity，通过Quantity的数量变化创建卡券
    if record.change_remain and record.change_remain.to_i != 0
      quantities.build(:number=>change_remain)
    end
  end

  def dynamic?
    indate_type.to_sym == :dynamic if indate_type
  end

  def fixed?
    indate_type.to_sym == :fixed if indate_type
  end

  def check phone, by_phone, number=1
    if can_check? != true
      can_check?
    elsif cards.acquired_by(phone).checkable.size < number
      :number_overflow
    elsif can_check_by_phone? by_phone != true
      :by_phone_no_permission
    else
      result = false
      Card.transaction do
        result = cards.acquired_by(phone).checkable.limit(number).update_all(:checked_at=>DateTime.now,:checker_phone=>by_phone)
        if result != number
          raise ActiveRecord::Rollback
        end
        client.create_activity key: 'card.check', owner: Member.find_by_phone(by_phone), recipient: self, :parameters=>{:phone=>phone, :by_phone=>by_phone, :number=>number,:type=>'核销',:msg=>"#{phone}被核销了#{number}张卡券,操作员#{by_phone}"}
      end
      result
    end
  end

  # 手机号群组权限， 匿名券无需判断
  def groups_can_acquire? phone=''
    if self.class.anonymous.include? self.id
      return true
    else
      return self.members.exists?(:phone=>phone)
    end
  end

  def period_phone_can_acquire_count phone
    if self.class.anonymous.exists? self.id
      return 1000
    end
    
    if period = period_now
      from = DateTime.now.change({ hour: period.from.hour, min: period.from.min, sec: 0 })
      to = DateTime.now.change({ hour: period.to.hour, min: period.to.min, sec: 0 })
      acquired_at_gt = Card.arel_table[:acquired_at].gt(from)
      acquired_at_lt = Card.arel_table[:acquired_at].lt(to)
      period.person_limit - cards.acquired_by(phone).where(acquired_at_gt).where(acquired_at_lt).size
    else
      0
    end
  end

  def period_card_can_acquire?
    if period = period_now
      from = DateTime.now.change({ hour: period.from.hour, min: period.from.min, sec: 0 })
      to = DateTime.now.change({ hour: period.to.hour, min: period.to.min, sec: 0 })
      acquired_at_gt = Card.arel_table[:acquired_at].gt(from)
      acquired_at_lt = Card.arel_table[:acquired_at].lt(to)
      period.number > cards.where(acquired_at_gt).where(acquired_at_lt).size
    else
      0
    end
  end

  # 验证用户
  def period_phone_can_acquire? phone
    if self.class.anonymous.exists?(id)
      return true
    else
      return period_phone_can_acquire_count(phone) > 0 
    end
  end

  # 验证用户
  def phone_can_acquire? phone
    if self.class.anonymous.exists?(id)
      return true
    else
      return cards.acquired_by(phone).size < person_limit
    end
  end

  # 游客券，会员券权限判断
  # 如果phone不是手机号时 ， 必须时游客券
  def acquire_type_can_acquire? phone
    if ChinaPhoneValidator.validate(phone) == false
      return self.acquire_type.to_sym == :anonymous
    else
      true
    end
  end

  # 根据agent是否公开权限
  # agent＝:user 说明是微信端领取，必须是公开券
  # agent＝:admin 说明是客户端发送，必须不是公开券
  def public_type_can_acquire? agent
    if agent.to_sym == :user
      return self.open? == true
    elsif agent.to_sym == :admin
      return self.open? == false
    end
  end

  def open?
    self.public == true
  end
  # 验证投放日期日期
  def datetime_can_acquire?
    # self.class.datetime_acquirable.exists?(id)
    self.from < DateTime.now && self.to < DateTime.now
  end

  # 验证投放时间
  def hour_can_acquire?
    self.class.hour_acquirable.exists?(id)
  end

  # 验证投放星期
  def week_can_acquire?
    self.class.week_acquirable.exists?self.id
  end

  # 验证核销时间
  def hour_can_check?
    self.class.hour_checkable.exists?self.id
  end

  # 验证核销星期
  def week_can_check?
    self.class.week_checkable.exists?self.id
  end

  def can_send_by_phone? phone
    if self.open?
      phone.blank?
    else
      self.class.sendable_by(phone).exists?(id)
    end
  end

  def can_check_by_phone? phone
    self.class.checkable_by(phone).exists?(id)
  end

  def cover_url(style=:medium)
    if cover.blank?
      ''
    else
      cover.url(style)
    end
  end

  def share_cover_url(style=:medium)
    if share_cover.blank?
      ''
    else
      share_cover.url(style)
    end
  end

  def guide_cover_url(style=:medium)
    if guide_cover.blank?
      ''
    else
      guide_cover.url(style)
    end
  end

  def acquire(phone, by_phone, number=1, agent=:admin)
    can_acquire = can_acquire?(phone, agent)
    if can_acquire === true
      can_send_by_phone = self.can_send_by_phone?(by_phone)
      if can_send_by_phone === true
        result = false

        Card.transaction do 
          conditions = {:phone=>phone, :acquired_at=>DateTime.now, :sender_phone=>by_phone}
          result = cards.acquirable.limit(number).update_all(conditions)
          if result != number
            raise ActiveRecord::Rollback
          end

          CardA.where(conditions).fix_from_to
          send_message_acquired_cards phone, number

          client.create_activity key: 'card.acquire', owner: Member.find_by_phone(by_phone), recipient: self, :parameters=>{:phone=>phone, :by_phone=>by_phone, :number=>number,:type=>'发券',:msg=>"#{phone}获得了#{number}张卡券,操作员#{by_phone}"}
          member = Member.get_instance_by_phone(phone)
          group = client.groups.default.first

          if group && member
            group.group_members << GroupMember.new(:phone=>member.phone, :started_at=>DateTime.now, :ended_at=>DateTime.now + GroupMember::DEFAULT_PERIOD)
            # group.members << member
          end
        end
        return result
      else
        return can_send_by_phone
      end
    else
      return can_acquire
    end
  end

  def send_message_acquired_cards phone, number
    unless phone.blank?
      config = {
        'type'=>'acquired_cards',
        'smsType'=>'normal',
        'smsFreeSignName'=>'红券',
        'smsParam'=>{cardnumber: number.to_s, brand: client.try(:brand).to_s, cardname: title.to_s, wechatid: client.try(:wechat_account) },
        'recNum'=>phone,
        'smsTemplateCode'=>'SMS_8970466'
      }
      Dayu.createByDayuable(self, config).run
    end
  end

  def send_message_checked_cards phone, number
    config = {
      'type'=>'acquired_cards',
      'smsType'=>'normal',
      'smsFreeSignName'=>'红券',
      'smsParam'=>{phonenumber: phone.to_s, brand: client.try(:brand).to_s, cardname: title.to_s, wechatid: client.try(:wechat_account) },
      'recNum'=>phone,
      'smsTemplateCode'=>'SMS_8495282'
    }
    Dayu.createByDayuable(self, config).run
  end

  def self.can_acquire? id, phone, agent
    record = find_by_id(id)
    if record
      record.can_acquire? phone, agent
    else
      :no_record
    end
  end

  # 判断卡券是否能被member投放
  def self.can_send_by_phone? id, phone
    record = find_by_id(id)
    if record
      record.can_send_by_phone?(phone)
    else
      :no_record
    end
  end

  # 判断卡券是否能被member投放
  def self.can_check_by_phone? id, phone
    record = find_by_id(id)
    if record
      record.can_check_by_phone?(phone)
    else
      :no_record
    end
  end

  def self.acquire(id, phone, by_phone, number=1, agent=:admin)
    record = find_by_id(id)
    if record
      record.acquire(phone, by_phone, number, agent)
    else
      :no_record
    end
  end

  def update_setting
    if self.setting.nil?
      self.setting = CardTplSetting.new(:card_tpl_id=>id)
    end

    [:check_monday,:check_tuesday,:check_wednesday,:check_thursday,:check_friday,:check_saturday,:check_sunday,:acquire_monday,:acquire_tuesday,:acquire_wednesday,:acquire_thursday,:acquire_friday,:acquire_saturday,:acquire_sunday,:check_h0,:check_h1,:check_h2,:check_h3,:check_h4,:check_h5,:check_h6,:check_h7,:check_h8,:check_h9,:check_h10,:check_h11,:check_h12,:check_h13,:check_h14,:check_h15,:check_h16,:check_h17,:check_h18,:check_h19,:check_h20,:check_h21,:check_h22,:check_h23].each do |column|
      self.setting.send("#{column}=", false)
    end

    (check_weeks||[]).reject(&:empty?).each do |week|
      check_method = "check_#{week}="
      if self.setting.respond_to?(check_method)
        self.setting.send(check_method, 1)
      end
    end

    (check_hours||[]).reject(&:empty?).each do |hour|
      check_method = "check_#{hour}="
      if self.setting.respond_to?(check_method)
        self.setting.send(check_method, 1)
      end
    end

    (acquire_weeks||[]).reject(&:empty?).each do |week|
      acquire_method = "acquire_#{week}="
      if self.setting.respond_to?(acquire_method)
        self.setting.send(acquire_method, 1)
      end
    end

    self.setting.save
  end

  def anonymous?
    self.acquire_type.to_sym == :anonymous
  end

  private

  def self.inheritance_column
    'type'
  end 

  def self.default_scope
    where type: [:CardBTpl,:CardATpl]
  end

  # 卡券是否可核销 , 需要结合卡密核销函数 card.can_check?
  def _can_check?
    if week_can_check? != true
      return :week_not_checkable
    elsif hour_can_check? != true
      return :hour_not_checkable
    else
      true
    end
  end

  # 计算得出当前时间所在的period
  def period_now
    now = DateTime.now
    time = "#{now.hour}:#{now.minute}:00"
    where_from = Period.arel_table[:from].lt(time)
    where_to = Period.arel_table[:to].gt(time)
    periods.where(where_from).where(where_to).first
  end
end
