class AddCapchaToMembers < ActiveRecord::Migration
  def change
    add_column :members, :recover_password_capcha, :string, {:limit=>10}
    add_column :members, :update_password_capcha, :string, {:limit=>10}
    add_column :members, :bind_wechat_capcha, :string, {:limit=>10}
  end
end
