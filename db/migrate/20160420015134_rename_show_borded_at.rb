class RenameShowBordedAt < ActiveRecord::Migration
  def change
  	rename_column :clients, :show_borded_at, :show_borned_at
  end
end
