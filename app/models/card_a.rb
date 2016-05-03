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
    if CardTpl.fixed.exists?(card_tpl_id)
      self.from = card_tpl.indate_from
      self.to = card_tpl.indate_to
    end

    if CardTpl.dynamic.exists?(card_tpl_id)
      self.from = Date.today + (card_tpl.indate_today ? 0 : 1).days
      self.to = Date.today + (card_tpl.indate_today ? 0 : 1).days + (card_tpl.indate_after - 1).days
    end
  end
end