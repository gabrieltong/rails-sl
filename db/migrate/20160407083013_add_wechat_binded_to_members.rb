class AddWechatBindedToMembers < ActiveRecord::Migration
  def change
    add_column :members, :wechat_binded, :boolean
    add_index :members, :wechat_binded
  end
end
