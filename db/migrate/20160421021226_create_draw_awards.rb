class CreateDrawAwards < ActiveRecord::Migration
  def change
    create_table :draw_awards do |t|
      t.integer :card_tpl_id
      t.string :title
      t.integer :award_id
      t.integer :number

      t.timestamps null: false
    end
    add_index :draw_awards, :card_tpl_id
    add_index :draw_awards, :award_id
  end
end
