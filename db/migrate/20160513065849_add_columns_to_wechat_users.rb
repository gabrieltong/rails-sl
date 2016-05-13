class AddColumnsToWechatUsers < ActiveRecord::Migration
  def change
    add_column :wechat_users, :expires_in, :integer
    add_column :wechat_users, :scope, :string
    add_index :wechat_users, :scope
  end
end
