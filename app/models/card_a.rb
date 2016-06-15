class CardA < Card
  validates :code, :uniqueness=>true
  validates :code, :presence=>true

  before_validation do |record|
    record.generate_code
    record.generate_from_to
  end
  
  after_create do |record|
    record.generate_code
  end

  def generate_code
    if code.blank? and card_tpl.is_a? CardATpl
      self.code = loop do
        random_code = rand(100000000000...999999999999)
        break random_code unless self.class.exists?(code: random_code)
      end
    end
  end

  def generate_from_to
    if self.from.blank?
      if CardTpl.fixed.exists?(card_tpl_id)
        self.from = card_tpl.indate_from
        self.to = card_tpl.indate_to
      end

      # 动态有效期类型不需要from to , from to 在领取时才会生效
      if CardTpl.dynamic.exists?(card_tpl_id)
        # self.from = DateTime.now.change({ hour: 0, min: 0, sec: 0 }) - 1.days
        # self.to = DateTime.now.change({ hour: 0, min: 0, sec: 0 }) + 10.years
      end
    end
  end
end