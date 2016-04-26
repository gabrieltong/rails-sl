class AddFromAndToToCards < ActiveRecord::Migration
  def change
    add_column :cards, :from, :datetime
    add_column :cards, :to, :datetime
  end
end
