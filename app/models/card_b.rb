# encoding: UTF-8
class CardB < Card
	delegate 'can_check?', :to=>:locked_card, :allow_nil=>true
	delegate :check, :to=>:locked_card, :allow_nil=>true
	delegate :code, :to=>:locked_card, :allow_nil=>true
  delegate :phone, :to=>:locked_card, :allow_nil=>true
  delegate :from, :to=>:locked_card, :allow_nil=>true
  delegate :to, :to=>:locked_card, :allow_nil=>true
	
	validates :code, inclusion: { in: [nil] }

	
	# scope :no_bingo, ->{where.not(:locked_id=>nil).where.not(:acquired_at=>nil)}

  before_validation do |record|
    record.generate_from_to
  end

# 确认抽奖券都是在有效期内
  def generate_from_to
		self.from = DateTime.now.change({ hour: 0, min: 0, sec: 0 }) - 100.years
    self.to = DateTime.now.change({ hour: 0, min: 0, sec: 0 }) + 100.years
  end
end