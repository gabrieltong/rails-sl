class Quantity < ActiveRecord::Base
  belongs_to :card_tpl
  belongs_to :member
  has_many :added_cards, :class_name=>:Card, :foreign_key=>:added_quantity_id
  has_many :removed_cards, ->{where.not(:deleted_at=>nil)}, :class_name=>:Card, :foreign_key=>:removed_quantity_id

  counter_culture :card_tpl, :column_name => 'total', :delta_column => 'number'
  counter_culture :card_tpl, :column_name => 'remain', :delta_column => 'number'

  validates :number, :numericality => {:only_integer => true, :other_than=>0}
  validates :number, :card_tpl_id, :presence=>true

  after_create do |record|
    record.generate_cards
  end

  def generate_cards
    if number > 0
      Card.transaction do
        (number - added_cards.size).times do
          card = self.added_cards.build(:card_tpl_id=>card_tpl_id)
          card.save
        end
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
