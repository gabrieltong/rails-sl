class ChangeClientIdAuto < ActiveRecord::Migration
  def change
  	execute ("ALTER TABLE clients AUTO_INCREMENT = 52366")
  end
end
