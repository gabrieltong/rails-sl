class ChangeCardTplSettings < ActiveRecord::Migration
  def change
		rename_column :card_tpl_settings, :use_mon,	:check_monday
		add_index :card_tpl_settings, :check_monday
		rename_column :card_tpl_settings, :use_tue,	:check_tuesday
		add_index :card_tpl_settings, :check_tuesday
		rename_column :card_tpl_settings, :use_wed,	:check_wednesday
		add_index :card_tpl_settings, :check_wednesday
		rename_column :card_tpl_settings, :use_thu,	:check_thursday
		add_index :card_tpl_settings, :check_thursday
		rename_column :card_tpl_settings, :use_fri,	:check_friday
		add_index :card_tpl_settings, :check_friday
		rename_column :card_tpl_settings, :use_sat,	:check_saturday
		add_index :card_tpl_settings, :check_saturday
		rename_column :card_tpl_settings, :use_sun,	:check_sunday
		add_index :card_tpl_settings, :check_sunday

		rename_column :card_tpl_settings, :get_mon,	:acquire_monday
		add_index :card_tpl_settings, :acquire_monday
		rename_column :card_tpl_settings, :get_tue,	:acquire_tuesday
		add_index :card_tpl_settings, :acquire_tuesday
		rename_column :card_tpl_settings, :get_wed,	:acquire_wednesday
		add_index :card_tpl_settings, :acquire_wednesday
		rename_column :card_tpl_settings, :get_thu,	:acquire_thursday
		add_index :card_tpl_settings, :acquire_thursday
		rename_column :card_tpl_settings, :get_fri,	:acquire_friday
		add_index :card_tpl_settings, :acquire_friday
		rename_column :card_tpl_settings, :get_sat,	:acquire_saturday
		add_index :card_tpl_settings, :acquire_saturday
		rename_column :card_tpl_settings, :get_sun,	:acquire_sunday
		add_index :card_tpl_settings, :acquire_sunday

		rename_column :card_tpl_settings, :use_h00,	:check_h0
		add_index :card_tpl_settings, :check_h0
		rename_column :card_tpl_settings, :use_h01,	:check_h1
		add_index :card_tpl_settings, :check_h1
		rename_column :card_tpl_settings, :use_h02,	:check_h2
		add_index :card_tpl_settings, :check_h2
		rename_column :card_tpl_settings, :use_h03,	:check_h3
		add_index :card_tpl_settings, :check_h3
		rename_column :card_tpl_settings, :use_h04,	:check_h4
		add_index :card_tpl_settings, :check_h4
		rename_column :card_tpl_settings, :use_h05,	:check_h5
		add_index :card_tpl_settings, :check_h5
		rename_column :card_tpl_settings, :use_h06,	:check_h6
		add_index :card_tpl_settings, :check_h6
		rename_column :card_tpl_settings, :use_h07,	:check_h7
		add_index :card_tpl_settings, :check_h7
		rename_column :card_tpl_settings, :use_h08,	:check_h8
		add_index :card_tpl_settings, :check_h8
		rename_column :card_tpl_settings, :use_h09,	:check_h9
		add_index :card_tpl_settings, :check_h9
		rename_column :card_tpl_settings, :use_h10,	:check_h10
		add_index :card_tpl_settings, :check_h10
		rename_column :card_tpl_settings, :use_h11,	:check_h11
		add_index :card_tpl_settings, :check_h11
		rename_column :card_tpl_settings, :use_h12,	:check_h12
		add_index :card_tpl_settings, :check_h12
		rename_column :card_tpl_settings, :use_h13,	:check_h13
		add_index :card_tpl_settings, :check_h13
		rename_column :card_tpl_settings, :use_h14,	:check_h14
		add_index :card_tpl_settings, :check_h14
		rename_column :card_tpl_settings, :use_h15,	:check_h15
		add_index :card_tpl_settings, :check_h15
		rename_column :card_tpl_settings, :use_h16,	:check_h16
		add_index :card_tpl_settings, :check_h16
		rename_column :card_tpl_settings, :use_h17,	:check_h17
		add_index :card_tpl_settings, :check_h17
		rename_column :card_tpl_settings, :use_h18,	:check_h18
		add_index :card_tpl_settings, :check_h18
		rename_column :card_tpl_settings, :use_h19,	:check_h19
		add_index :card_tpl_settings, :check_h19
		rename_column :card_tpl_settings, :use_h20,	:check_h20
		add_index :card_tpl_settings, :check_h20
		rename_column :card_tpl_settings, :use_h21,	:check_h21
		add_index :card_tpl_settings, :check_h21
		rename_column :card_tpl_settings, :use_h22,	:check_h22
		add_index :card_tpl_settings, :check_h22
		rename_column :card_tpl_settings, :use_h23,	:check_h23		
		add_index :card_tpl_settings, :check_h23		
  end
end
