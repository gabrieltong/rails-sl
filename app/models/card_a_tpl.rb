class CardATpl < CardTpl
  validates :indate_type, :presence=>true
  validates :indate_type, :inclusion=>{:in=>IndateType.values}
  validates :indate_from, :indate_to, :presence=>true, :if=>"indate_type == 'fixed'"
  validates :indate_after, :presence=>true, :if=>"indate_type == 'dynamic'"
  validates_datetime :indate_from, :before=>:indate_to, :allow_blank=>true
  validates_datetime :indate_to, :after=>:indate_from, :allow_blank=>true

  alias_method :card_as, :cards

  validates :shops, :presence=> true
end