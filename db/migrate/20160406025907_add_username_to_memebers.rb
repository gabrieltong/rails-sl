class AddUsernameToMemebers < ActiveRecord::Migration
  def change
    add_column :members, :username, :string
    add_index :members, :username, :unique=>true

    add_column :members, :phone, :string
		add_index :members, :phone, :unique=>true
  end
end
