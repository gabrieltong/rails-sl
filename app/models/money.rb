class Money < ActiveRecord::Base
	belongs_to :client_member
	belongs_to :by_member, :class_name=>Member, :foreign_key=>:by_phone

	scope :charge, ->{where("money > 0")}
	scope :spend, ->{where("money < 0")}

	delegate :wechatid, to: :client_member, :allow_nil=>true
	delegate :member, to: :client_member
	delegate :client, to: :client_member


  def send_message_charge_money
    config = {
      'type'=>__callee__,
      'smsType'=>'normal',
      'smsFreeSignName'=>'红券',
      'smsParam'=>{brand: client.try(:brand), recharge: money.to_s, wechatid: ''},
      'recNum'=>phone,
      'smsTemplateCode'=>'SMS_8490409'
    }
    Dayu.createByDayuable(Member.first, config).run
  end

	private
	def self.table_name
		:moneys
	end
end
