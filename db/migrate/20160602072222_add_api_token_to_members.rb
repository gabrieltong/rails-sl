class AddApiTokenToMembers < ActiveRecord::Migration
  def change
    add_column :members, :api_token, :string
  end
end
