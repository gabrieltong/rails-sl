class CardA < Card
  validates :code, :uniqueness=>true
  validates :code, :presence=>true

  before_validation do |record|
    record.generate_code
  end
  
  before_create do |record|
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
end