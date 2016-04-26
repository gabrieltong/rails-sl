class AddCapchaToCards < ActiveRecord::Migration
  def change
    add_column :cards, :capcha, :string, {:default=>'', :limit=>10}
  end
end
