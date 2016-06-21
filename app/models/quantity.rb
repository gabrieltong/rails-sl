class Quantity < ActiveRecord::Base
  MaxBatch = 1000
  belongs_to :card_tpl
  belongs_to :member
  belongs_to :draw_award
  has_many :added_cards, :class_name=>:Card, :foreign_key=>:added_quantity_id
  has_many :removed_cards, ->{where.not(:deleted_at=>nil)}, :class_name=>:Card, :foreign_key=>:removed_quantity_id

  delegate :client_id, :to=>:card_tpl

  counter_culture :card_tpl, :column_name => 'total', :delta_column => 'number'
  counter_culture :card_tpl, :column_name => 'remain', :delta_column => 'number'

  validates :number, :numericality => {:only_integer => true, :other_than=>0}
  validates :number, :card_tpl_id, :presence=>true

  after_create do |record|
    record.generate_cards
  end

  def generate_cards
    if CardATpl.exists?(card_tpl_id)
      generate_cards_for_a
    end
    if CardBTpl.exists?(card_tpl_id)
      generate_cards_for_b
    end    
  end

  def self.generate_instance_for_award(award)
    quantity = self.new
    quantity.draw_award = award
    quantity.number = quantity.draw_award.number
    quantity.card_tpl_id = quantity.draw_award.card_tpl_id
    quantity.save
  end

  def generate_cards_for_b
    if number > 0

      coditions = {:card_tpl_id=>card_tpl_id, :code=>nil, :client_id=>client_id, :added_quantity_id=>self.id}
      test_card = CardB.new(coditions)
      raise '无法创建卡券' unless test_card.valid?

      total = number - added_cards.size
      if total > MaxBatch
        batch_group = [MaxBatch] * (total / MaxBatch) + [total % MaxBatch]
      else
        batch_group = [total]
      end
      
      batch_group.each do |n|
        cards = []
        n.times do
          cards << CardB.new(coditions)
        end
        CardB.import cards
      end
      

      if draw_award
        added_cards.locked_none.each do |locker|
          card = draw_award.award_tpl.cards.acquirable.first
          locker.lock(card) if card
        end
      end
      # card_tpl.draw_awards.each do |draw|
      #   logger.info (draw.number - added_cards.locked_other.size)
      #   self.added_cards.locked_none.not_locked.not_acquired.not_checked.limit(draw.number_need_create).each do |card_try_to_lock|
      #     logger.info :card_try_to_lock
      #     logger.info card_try_to_lock
      #     draw.award_tpl.cards.locked_none.not_locked.not_acquired.not_checked.limit(1).each do |card_to_be_locked|
      #       logger.info :card_to_be_locked
      #       logger.info card_to_be_locked
      #       card_try_to_lock.locked_card = card_to_be_locked
      #     end
      #   end
      # end
    end

    if number < 0
      card_tpl.cards.locked_none.not_locked.not_acquired.not_checked.limit(number.abs - removed_cards.size).each do |card|
        card.destroy
        card.removed_quantity = self
        card.save
      end
    end
  end

# TODO: 生成卡券密钥
  def generate_cards_for_a
    if number > 0
      (number - added_cards.size).times do
        self.added_cards << CardA.new(:card_tpl_id=>card_tpl_id, :client_id=>client_id)
      end
    end

    if number < 0
      # card_tpl.cards.not_acquired.limit(number.abs - removed_cards.size).destroy
      card_tpl.cards.not_acquired.limit(number.abs - removed_cards.size).each do |card|
        card.destroy
        card.removed_quantity = self
        card.save
      end
    end
  end

  def generate_cards_sql
    10.times do 
      sql = "insert into cards (card_tpl_id, added_quantity_id, created_at, updated_at, code) 
      (SELECT #{card_tpl_id}, #{id}, NOW(), NOW(), FLOOR(10 + RAND() * 10) AS random_number FROM cards WHERE 'random_number' NOT IN (SELECT code FROM `cards`) LIMIT 1)"
      ActiveRecord::Base.connection.execute sql
    end
  end
end
