class AddTypeToGabeDayus < ActiveRecord::Migration
  def up
  	create_table :gabe_dayus do |t|
  		t.string :type
  		t.string :smsType
  		t.string :smsFreeSignName
  		t.string :smsParam
  		t.string :recNum
  		t.string :smsTemplateCode
  		t.string :appkey
  		t.integer :dayuable_id
  		t.string :dayuable_type
  		t.string :result
  		t.datetime :sended_at
  		t.boolean :sended
  	end

  	add_index :gabe_dayus, :type
  	add_index :gabe_dayus, :smsType
  	add_index :gabe_dayus, :smsFreeSignName
  	add_index :gabe_dayus, :recNum
  	add_index :gabe_dayus, :smsTemplateCode
  	add_index :gabe_dayus, :sended
  	add_index :gabe_dayus, [:dayuable_id, :dayuable_type]
  end
end
