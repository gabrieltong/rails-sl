class ChangeClientId < ActiveRecord::Migration
  def change
  	execute ("ALTER TABLE clients AUTO_INCREMENT = 1000")
  end
end
