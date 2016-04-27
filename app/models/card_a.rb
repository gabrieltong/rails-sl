class CardA < Card
  validates :code, :uniqueness=>true
  validates :code, :presence=>true
end