# encoding: UTF-8
class Card < ActiveRecord::Base
  acts_as_paranoid
  # uniquify :code, :salt, :length => 12, :chars => 0..9
  belongs_to :card_tpl
  belongs_to :member, :foreign_key=>:phone, :primary_key=>:phone
  belongs_to :added_quantity, :class_name=>Quantity, :foreign_key=>:added_quantity_id
  belongs_to :removed_quantity, :class_name=>Quantity, :foreign_key=>:removed_quantity_id
  belongs_to :client
  has_many :dayus, :as=>:dayuable

  scope :acquired, ->{where.not(:acquired_at=>nil)}
  scope :checked, ->{where.not(:checked_at=>nil)}

  scope :not_acquired, ->{where(:acquired_at=>nil)}
  scope :not_checked, ->{where(:checked_at=>nil)}

  # 是否在可核销区间
  scope :active, ->{where(arel_table[:from].lt(DateTime.now)).where(arel_table[:to].gt(DateTime.now))}
  scope :inactive, ->{where(arel_table[:from].gt(DateTime.now).or(arel_table[:to].lt(DateTime.now)))}

  # 相当于 acquired.not_checked.active
  scope :checkable, ->{where(arel_table[:acquired_at].not_eq(nil)).where(arel_table[:checked_at].eq(nil)).where(arel_table[:from].lt(DateTime.now)).where(arel_table[:to].gt(DateTime.now))}


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

# 判断能否核销
  def can_check?
    return :not_acquired unless self.class.acquired.exists?(self.id)
    return :checked if self.class.checked.exists?(self.id)
    return :inactive unless self.class.active.exists?(self.id)
    card_tpl_can_check = self.card_tpl.can_check?
    return card_tpl_can_check unless card_tpl_can_check === true
    true
  end

  def can_check_by_member? member
    member.checker_card_tpls.include? card_tpl
  end

  def send_check_capcha
    if self.can_check? === true and Dayu.allow_send(self) === true
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
    code = "123456"
    return {
      'smsType'=>'normal',
      'smsFreeSignName'=>'前站',
      'smsParam'=>{code: capcha, product: '', item: title},
      'recNum'=>phone,
      'smsTemplateCode'=>'SMS_2145923'
    }
  end

# 改卡卷自身是否能核销 ，包含卡卷实例的验证， 包括卡卷模板的验证
  def self.can_check? code
    card = self.find_by_code(code)
    if card.nil?
      return :no_card
    else
      return card.can_check?
    end
  end

# 用户是否有核销某卡密的资格
  def self.can_check_by_member? code, member
    card = self.find_by_code(code)
    if card.nil?
      return :no_card
    else
      return card.can_check_by_member? member
    end
  end
# 核销需要验证的情况
# 已获得
# 未核销
# 验证码，密钥， 二者绑定
# 卡卷实例在有效期内
# 卡卷模板未下架
# 当前时间在可核销时间内
# 当前天(周1，2，3，4，5，6，7）在可核销cwday内
# 使用乐观锁
# 有可能需要验证码有效期
  def self.check(code, capcha)
    where_condition = {:code=>code, :capcha=>capcha}
    card = Card.where(where_condition).first
    if card
      can = card.can_check?
      if can === true
        result = checkable.where(where_condition).limit(1).update_all(:checked_at=>DateTime.now)
        return result > 0  
      else
        return can
      end
    else
      return :no_card
    end
  end
end
