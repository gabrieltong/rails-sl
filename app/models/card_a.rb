# encoding: UTF-8
class CardA < Card
  validates :code, :uniqueness=>true
  validates :code, :presence=>true

  before_validation do |record|
    record.generate_code
  end
  
  # 卡卷创建后再生成密钥，这时才有card_tpl, 才能判断是不是CardATpl
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
end