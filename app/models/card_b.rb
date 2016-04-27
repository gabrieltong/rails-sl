class CardB < Card
	delegate 'can_check?', :to=>:locked_card, :allow_nil=>true
	delegate 'check', :to=>:locked_card, :allow_nil=>true
	
	validates :code, inclusion: { in: [nil] }
end