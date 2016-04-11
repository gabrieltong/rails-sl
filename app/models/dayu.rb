class Dayu < ActiveRecord::Base
	belongs_to :dayuable, :polymorphic=>true

	scope :findByDayuable, -> (obj) { where(:dayuable_type => obj.class.name, :dayuable_id => obj.id) }

	def self.createByDayuable(dayuable)
		config = dayuable.dayuConfig
		dayu = self.new
    dayu.smsType = config['smsType']
    dayu.smsFreeSignName = config['smsFreeSignName']
    dayu.smsParam = config['smsParam']
    dayu.recNum = config['recNum']
    dayu.smsTemplateCode = config['smsTemplateCode']
    dayu.dayuable_type = dayuable.class.name
    dayu.dayuable_id = dayuable.id
    dayu.appkey = 123
    dayu.sended_at = '0000-00-00 00:00:00'
    dayu.save
    dayu
	end

	def self.table_name
    :gabe_dayus
  end

  def config(ak, sk)
  	@ak = ak || '23265315'
  	@sk = sk || 'a01020d3de3b53fc9cd86ed51d8bb981'
  end

  def send
    `
    php #{LaPath} dayu:send #{self.id}
    `
  end
end