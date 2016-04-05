class AddWechatLogoToClients < ActiveRecord::Migration
	def up
    add_attachment :clients, :wechat_logo
  end

  def down
    remove_attachment :clients, :wechat_logo
  end
end
