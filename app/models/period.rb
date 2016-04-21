class Period < ActiveRecord::Base
	validates_time :from, :before=>:to
	validates_time :to, :after=>:from
	validates :number, :numericality => {:only_integer => true, :greater_than => 0}
	validates :person_limit, :numericality => {:only_integer => true, :greater_than => 0}
end
