class CreateWechatUsers < ActiveRecord::Migration
  def change
    create_table :wechat_users do |t|
      t.string :phone
      t.string :openid
      t.string :unionid
      t.string :nickname
      t.integer :sex
      t.string :language
      t.string :city
      t.string :province
      t.string :country
      t.string :headimgurl
      t.string :access_token
      t.string :refresh_token

      t.timestamps null: false
    end
    add_index :wechat_users, :phone
    add_index :wechat_users, :openid, :unique=>true
    add_index :wechat_users, :unionid
    add_index :wechat_users, :sex
    add_index :wechat_users, :language
    add_index :wechat_users, :city
    add_index :wechat_users, :province
    add_index :wechat_users, :country
  end
end
