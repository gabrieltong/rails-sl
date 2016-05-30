class Period < ActiveRecord::Base
  validates_time :from, :before=>:to
  validates_time :to, :after=>:from
  validates :number, :numericality => {:only_integer => true, :greater_than => 0}
  validates :person_limit, :numericality => {:only_integer => true, :greater_than => 0}
  before_save do |record|
    if record.to.min == 59
      record.to = record.to.change(:sec=>59)
    end
  end
end
