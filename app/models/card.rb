# encoding: UTF-8
class Card < ActiveRecord::Base
  acts_as_paranoid
  # uniquify :code, :salt, :length => 12, :chars => 0..9
  belongs_to :card_tpl
  belongs_to :member, :foreign_key=>:phone, :primary_key=>:phone
  belongs_to :added_quantity, :class_name=>Quantity, :foreign_key=>:added_quantity_id
  belongs_to :removed_quantity, :class_name=>Quantity, :foreign_key=>:removed_quantity_id
  belongs_to :client
  belongs_to :checker, :class_name=>Member, :foreign_key=>:checker_phone, :primary_key=>:phone
  belongs_to :sender, :class_name=>Member, :foreign_key=>:sender_phone, :primary_key=>:phone
  has_one :locked_card, :class_name=>Card, :foreign_key=>:locked_by_id
  belongs_to :locked_by_card, :class_name=>Card, :foreign_key=>:locked_by_id

  has_many :dayus, :as=>:dayuable

  delegate 'can_check_by_phone?', :to=>:card_tpl
  delegate :title, :to=>:card_tpl
  delegate :indate_type, :to=>:card_tpl
  delegate :indate_after, :to=>:card_tpl
  delegate :indate_from, :to=>:card_tpl
  delegate :indate_to, :to=>:card_tpl
  delegate :indate_today, :to=>:card_tpl

  scope :by_client, ->(client_id){where(:client_id=>client_id)}
  scope :acquired_by, ->(phone){where(:phone=>phone)}
  scope :sended_by, ->(phone){where(:sender_phone=>phone)}
  scope :checked_by, ->(phone){where(:checker_phone=>phone)}
  scope :locked_by, ->(card_id){where(:locked_by_id=>card_id)}
  scope :locked_by_tpl, ->(card_tpl_id){where(:locked_by_tpl_id=>card_tpl_id)}

  scope :has_locked, ->{where.not(:locked_id=>nil)}
  scope :locked, ->{where.not(:locked_by_id=>nil)}
  scope :acquired, ->{where.not(:acquired_at=>nil)}
  scope :acquired_by_phone, ->{where.not(:acquired_at=>nil, :phone=>nil)}
  # scope :acquired_by_openid, ->{where.not(:acquired_at=>nil, :openid=>nil)}
  scope :acquired_by_anonymous, ->{where(:phone=>nil).where.not(:acquired_at=>nil)}
  scope :checked, ->{where.not(:checked_at=>nil)}

  scope :locked_none, ->{where(:locked_id=>nil)}
  scope :not_locked, ->{where(:locked_by_id=>nil)}
  scope :not_acquired, ->{where(:acquired_at=>nil)}
  scope :not_checked, ->{where(:checked_at=>nil)}

  scope :bingo, ->{where.not(:locked_id=>nil).where.not(:acquired_at=>nil)}

  # 是否在可核销区间
  scope :active, ->{where(arel_table[:from].lt(DateTime.now)).where(arel_table[:to].gt(DateTime.now))}
  scope :inactive, ->{where(arel_table[:from].gt(DateTime.now).or(arel_table[:to].lt(DateTime.now)))}

  # 相当于 acquired.not_checked.active
  scope :checkable, ->{where(arel_table[:acquired_at].not_eq(nil)).where(arel_table[:checked_at].eq(nil)).where(arel_table[:from].lt(DateTime.now)).where(arel_table[:to].gt(DateTime.now))}

  scope :acquirable, ->{where(:acquired_at=>nil, :locked_by_id=>nil).where(arel_table[:from].lt(DateTime.now).or(arel_table[:from].eq(nil))).where(arel_table[:to].gt(DateTime.now).or(arel_table[:to].eq(nil)))}

  scope :acquired_in_range, ->(from, to){where(arel_table[:acquired_at].gt(from)).where(arel_table[:acquired_at].lt(to))}
  scope :checked_in_range, ->(from, to){where(arel_table[:checked_at].gt(from)).where(arel_table[:checked_at].lt(to))}
  scope :will_expire, ->(seconds=60*60*24) {where(arel_table[:to].lt(DateTime.now + seconds.seconds)).where(arel_table[:to].gt(DateTime.now))}

  validates :card_tpl_id, :added_quantity_id, :presence=>true
  
  validates :type, :inclusion => %w(CardA CardB)
  validates :removed_quantity_id, :presence => true, :if=>'!deleted_at.nil?'
  validates :phone, :presence => true, :if=>'!acquired_at.blank?'
  validates :acquired_at, :presence => true, :if=>'!phone.blank?'

  before_validation do |record|
    record.generate_type
  end
  
  before_save do |record|
    record.generate_locked_info
  end

  def self.inheritance_column
    'type'
  end

# 冗余：locked_id, locked_tpl_id
  def generate_locked_info
    # 为被绑定的卡券生成冗余
    if locked_by_card
      self.locked_by_tpl_id = locked_by_card.card_tpl_id
      if locked_by_card.locked_id.nil?
        # 为绑定其他卡券的卡券生成冗余
        locked_by_card.locked_id = id
        locked_by_card.locked_tpl_id = card_tpl_id
        locked_by_card.save
      end
    end
  end
# 为卡密生成正确类型
  def generate_type
    if card_tpl.is_a? CardATpl
      self.type = :CardA
    end

    if card_tpl.is_a? CardBTpl
      self.type = :CardB
    end
  end

# 测试用代码
  def self.generate_depot(number = 10**6)
    number.times do
      card = Card.new
      card.save :validate=>false  
    end
  end

# 核销需要验证的情况
# 验证码，密钥， 二者绑定 card.capcha == capcha

# 已获得 scope card.acquired
# 未核销 scope card.not_checked
# 卡券实例在有效期内 scope card.active

# 卡券模板未下架 scope card_tpl.active or card_tpl.paused
# 当前时间在可核销时间内 hour in use_hours 
# 当前天(周1，2，3，4，5，6，7）在可核销cwday内 : cwday in use_weeks
# 使用乐观锁
# 有可能需要验证码有效期 
# 判断能否核销
  def can_check?
    return :not_acquired unless self.class.acquired.exists?(self.id)
    return :checked unless self.class.not_checked.exists?(self.id)
    return :datetime_not_checkable unless self.class.active.exists?(self.id)
    card_tpl_can_check = self.card_tpl.can_check?
    return card_tpl_can_check unless card_tpl_can_check === true
    true
  end

  def send_check_capcha
    if self.can_check? === true and Dayu.allow_send(self, check_capcha_config['type']) === true
      self.capcha = rand(100000..999999)
      self.save
      dy = Dayu.createByDayuable(self, check_capcha_config)
      dy.run
    else
      false
    end
  end

  def check_capcha_config
    title = "#{card_tpl.title}的验证码"
    return {
      'type'=>'check',
      'smsType'=>'normal',
      'smsFreeSignName'=>'前站',
      'smsParam'=>{code: capcha, product: '', item: title},
      'recNum'=>phone,
      'smsTemplateCode'=>'SMS_2145923'
    }
  end

# 改卡券自身是否能核销 ，包含卡券实例的验证， 包括卡券模板的验证
  def self.can_check? code
    card = self.find_by_code(code)
    if card.nil?
      return :no_record
    else
      return card.can_check?
    end
  end

# 用户是否有核销某卡密的资格
  def self.can_check_by_phone? code, phone
    card = self.find_by_code(code)
    if card.nil?
      return :no_record
    else
      return card.can_check_by_phone? phone
    end
  end

  def self.check(code, by_phone)
    where_condition = {:code=>code}
    # 验证卡密是否存在
    card = self.where(where_condition).first
    if card
      can_check = card.can_check?
      # 验证卡密权限
      if can_check === true 
        can_check_by_phone = card.can_check_by_phone?(by_phone)
        # 验证用户权限
        if can_check_by_phone === true
          result = checkable.where(where_condition).limit(1).update_all(:checked_at=>DateTime.now,:checker_phone=>by_phone)
          return result > 0
        else
          return can_check_by_phone
        end
      else
        return can_check
      end
    else
      return :no_record
    end
  end

  # 用户给参与用户发送卡券密码
  def send_message_acquired

    config = {
      'type'=>__callee__,
      'smsType'=>'normal',
      'smsFreeSignName'=>'红券',
      'smsParam'=>{product: client.title.to_s, item: card_tpl.title.to_s, code: code.to_s},
      'recNum'=>phone,
      'smsTemplateCode'=>'SMS_2165442'
    }
  
    dy = Dayu.createByDayuable(self, config)
    dy.run
    dy.sended
  end

  def fix_card_tpl
    self.client_id = added_quantity.client_id
    save
  end

  def send_message_will_expire
    if Dayu.allow_send self, __callee__, 60*60*24
      config = {
        'type'=>__callee__,
        'smsType'=>'normal',
        'smsFreeSignName'=>'红券',
        'smsParam'=>{brand: client.try(:brand), cardname: card_tpl.try(:title),  wechatid: client.try(:wechat_account)},
        'recNum'=>phone,
        'smsTemplateCode'=>'SMS_8525379'
      }
      Dayu.createByDayuable(self, config).run
    end
  end

  def self.send_message_will_expire
    # Card.where(:phone=>13654265306).limit(1) do |record|
    checkable.will_expire.each do |record|
      if Dayu.allow_send record, :send_message_will_expire
        record.send_message_will_expire
      end
    end
  end
end
