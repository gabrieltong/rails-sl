class CreateCardTplSettings < ActiveRecord::Migration
  def change
    create_table :card_tpl_settings do |t|
      t.integer :card_tpl_id
      t.boolean :use_mon
      t.boolean :use_tue
      t.boolean :use_wed
      t.boolean :use_thu
      t.boolean :use_fri
      t.boolean :use_sat
      t.boolean :use_sun
      t.boolean :get_mon
      t.boolean :get_tue
      t.boolean :get_wed
      t.boolean :get_thu
      t.boolean :get_fri
      t.boolean :get_sat
      t.boolean :get_sun
      t.boolean :use_h00
      t.boolean :use_h01
      t.boolean :use_h02
      t.boolean :use_h03
      t.boolean :use_h04
      t.boolean :use_h04
      t.boolean :use_h05
      t.boolean :use_h06
      t.boolean :use_h07
      t.boolean :use_h08
      t.boolean :use_h09
      t.boolean :use_h10
      t.boolean :use_h11
      t.boolean :use_h12
      t.boolean :use_h13
      t.boolean :use_h14
      t.boolean :use_h15
      t.boolean :use_h16
      t.boolean :use_h17
      t.boolean :use_h18
      t.boolean :use_h19
      t.boolean :use_h20
      t.boolean :use_h21
      t.boolean :use_h22
      t.boolean :use_h23

      t.timestamps null: false
    end
    add_index :card_tpl_settings, :card_tpl_id
  end
end
