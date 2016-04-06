class ChangeMemberId < ActiveRecord::Migration
  def change
  	execute ("ALTER TABLE members AUTO_INCREMENT = 10000000")
  end
end
