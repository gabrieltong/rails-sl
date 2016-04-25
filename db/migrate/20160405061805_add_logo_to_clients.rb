class AddLogoToClients < ActiveRecord::Migration
	def up
    add_attachment :clients, :logo
  end

  def down
    remove_attachment :clients, :logo
  end
end
