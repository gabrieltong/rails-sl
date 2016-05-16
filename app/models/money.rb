class Money < ActiveRecord::Base
	belongs_to :client_member
	belongs_to :by_member, :class_name=>Member, :foreign_key=>:by_phone
	belongs_to :client

	scope :charge, ->{where(arel_table[:money].gt(0))}
	scope :spend, ->{where(arel_table[:money].lt(0))}
	scope :by_client, ->(client_id){where(:client_id=>client_id)}

	delegate :wechatid, to: :client_member, :allow_nil=>true
	delegate :member, to: :client_member
	delegate :title, to: :client, :prefix=>true, :allow_nil=>true


  def send_message_charge_money
    config = {
      'type'=>__callee__,
      'smsType'=>'normal',
      'smsFreeSignName'=>'红券',
      'smsParam'=>{brand: client.try(:brand), recharge: money.to_s, wechatid: ''},
      'recNum'=>phone,
      'smsTemplateCode'=>'SMS_8490409'
    }
    Dayu.createByDayuable(member, config).run
  end

	private
	def self.table_name
		:moneys
	end
end
