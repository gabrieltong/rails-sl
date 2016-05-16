class AddColumns3ToClientMembers < ActiveRecord::Migration
  def change
    add_column :client_members, :license_plate, :string, {:default=>''}
    add_column :client_members, :identity, :string, {:default=>''}
    add_column :client_members, :position, :string, {:default=>''}
    add_column :client_members, :company, :string, {:default=>''}
    add_index :client_members, :company
    add_column :client_members, :collage, :string, {:default=>''}
    add_index :client_members, :collage
    add_column :client_members, :emotion, :string, {:default=>''}
    add_index :client_members, :emotion
    add_column :client_members, :car_type, :string, {:default=>''}
    add_column :client_members, :remark, :string, {:default=>'', :limit=>3000}

    add_column :clients, :show_license_plate, :boolean, {:default=>1}
    add_column :clients, :show_identity, :boolean, {:default=>1}
    add_column :clients, :show_position, :boolean, {:default=>1}
    add_column :clients, :show_company, :boolean, {:default=>1}
    add_index :clients, :show_company
    add_column :clients, :show_collage, :boolean, {:default=>1}
    add_index :clients, :show_collage
    add_column :clients, :show_emotion, :boolean, {:default=>1}
    add_index :clients, :show_emotion
    add_column :clients, :show_car_type, :boolean, {:default=>1}
    add_column :clients, :show_remark, :boolean, {:default=>1}
  end
end
