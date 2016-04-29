class CreateMoney < ActiveRecord::Migration
  def change
    create_table :moneys do |t|
      t.integer :member_id
      t.integer :client_id
      t.integer :client_member_id
      t.float :money
      t.integer :spendable_id
      t.string :spendable_type
      t.integer :by_member_id
      t.string :type

      t.timestamps null: false
    end
    add_index :moneys, :member_id
    add_index :moneys, :client_id
    add_index :moneys, :client_member_id
    add_index :moneys, :spendable_id
    add_index :moneys, :spendable_type
    add_index :moneys, :by_member_id
    add_index :moneys, :type
  end
end
