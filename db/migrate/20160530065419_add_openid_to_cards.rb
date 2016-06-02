class AddOpenidToCards < ActiveRecord::Migration
  def change
    add_column :cards, :openid, :string
    add_index :cards, :openid
  end
end
