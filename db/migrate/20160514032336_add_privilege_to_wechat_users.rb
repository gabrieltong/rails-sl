class AddPrivilegeToWechatUsers < ActiveRecord::Migration
  def change
    add_column :wechat_users, :privilege, :string, {:limit=>1000}
  end
end
