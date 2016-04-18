class Dayu < ActiveRecord::Base
  belongs_to :dayuable, :polymorphic=>true

  scope :findByDayuable, -> (obj) { where(:dayuable_type => obj.class.name, :dayuable_id => obj.id) }

  serialize :smsParam
  
  def self.createByDayuable(dayuable, config)
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

  def run
    bigfish = Alibaba::Bigfish.new(23265315,'a01020d3de3b53fc9cd86ed51d8bb981')

    params = {
        rec_num: recNum , 
        sms_type: smsType, 
        sms_free_sign_name: smsFreeSignName, 
        sms_template_code: smsTemplateCode, 
        sms_param: smsParam
    }

    result = bigfish.send_sms params
    self.result = result
    
    begin
      if JSON.parse(result).values[0]['result']['success'] == true
        self.sended_at = DateTime.now
        self.sended = true
      end
    rescue
    end

    self.save
  end

  private
  def run2
    `
    php #{LaPath} dayu:send #{self.id}
    `
  end     
end