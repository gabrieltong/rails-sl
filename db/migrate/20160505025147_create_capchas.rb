class CreateCapchas < ActiveRecord::Migration
  def change
    create_table :capchas do |t|
      t.string :phone
      t.string :type
      t.datetime :expired_at
      t.datetime :deleted_at
      t.string :code

      t.timestamps null: false
    end
    add_index :capchas, :phone
    add_index :capchas, :type
    add_index :capchas, :deleted_at
  end
end
