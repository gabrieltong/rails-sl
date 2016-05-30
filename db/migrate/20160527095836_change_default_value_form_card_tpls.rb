class ChangeDefaultValueFormCardTpls < ActiveRecord::Migration
  def change  
    change_column :card_tpl_settings, :check_monday, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_tuesday, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_wednesday, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_thursday, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_friday, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_saturday, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_sunday, :boolean, {:default=>1}
    change_column :card_tpl_settings, :acquire_monday, :boolean, {:default=>1}
    change_column :card_tpl_settings, :acquire_tuesday, :boolean, {:default=>1}
    change_column :card_tpl_settings, :acquire_wednesday, :boolean, {:default=>1}
    change_column :card_tpl_settings, :acquire_thursday, :boolean, {:default=>1}
    change_column :card_tpl_settings, :acquire_friday, :boolean, {:default=>1}
    change_column :card_tpl_settings, :acquire_saturday, :boolean, {:default=>1}
    change_column :card_tpl_settings, :acquire_sunday, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h0, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h1, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h2, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h3, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h4, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h4, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h5, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h6, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h7, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h8, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h9, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h10, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h11, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h12, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h13, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h14, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h15, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h16, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h17, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h18, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h19, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h20, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h21, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h22, :boolean, {:default=>1}
    change_column :card_tpl_settings, :check_h23, :boolean, {:default=>1}
  end
end
