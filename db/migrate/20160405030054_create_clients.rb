class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :title
      t.string :reg
      t.string :address
      t.string :position
      t.float :location_y
      t.float :localtion_x
      t.string :phone
      t.string :area
      t.string :type
      t.date :service_started
      t.date :service_ended_at
      t.string :website
      t.string :wechat_account
      t.string :wechat_title

      t.timestamps null: false
    end
  end
end
