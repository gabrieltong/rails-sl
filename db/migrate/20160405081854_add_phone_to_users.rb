class AddPhoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_column :users, :wechat_binded, :boolean
  end
end
