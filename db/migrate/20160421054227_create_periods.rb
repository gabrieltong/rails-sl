class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.integer :card_tpl_id
      t.string :from
      t.string :to
      t.integer :number
      t.string :type
      t.integer :person_limit

      t.timestamps null: false
    end
    add_index :periods, :card_tpl_id
    add_index :periods, :type
  end
end
