class AddCapchaExpiredAtToMembers < ActiveRecord::Migration
  def change
    add_column :members, :capcha, :string, :after=>:remember_token
    add_index :members, :capcha
    add_column :members, :capcha_expired_at, :datetime
  end
end
