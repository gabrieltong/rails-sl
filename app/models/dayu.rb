class Dayu < ActiveRecord::Base
  belongs_to :dayuable, :polymorphic=>true

  scope :findByDayuable, -> (obj) { where(:dayuable_type => obj.class.name, :dayuable_id => obj.id) }

  serialize :smsParam

  validates :smsType, :smsFreeSignName, :smsParam, :recNum, :smsTemplateCode, :dayuable_id, :dayuable_type, :type, :presence => true

  scope :sended, ->{where(:sended=>true)}
  scope :not_sended, ->{where.not(:sended=>true)}
  scope :of_type, ->(type){where(:type=>type)}

  def self.createByDayuable(dayuable, config)
    dayu = self.new
    dayu.smsType = config['smsType']
    dayu.smsFreeSignName = config['smsFreeSignName']
    dayu.smsParam = config['smsParam']
    dayu.recNum = config['recNum']
    dayu.smsTemplateCode = config['smsTemplateCode']
    dayu.dayuable = dayuable
    dayu.appkey = 123
    dayu.type = config['type']
    dayu.sended_at = '0000-00-00 00:00:00'
    dayu.save
    dayu
  end

  def self.table_name
    :gabe_dayus
  end

  def run
    bigfish = Alibaba::Bigfish.new(ENV['Bigfish_AK'],ENV['Bigfish_SK'])

    params = {
        rec_num: recNum , 
        sms_type: smsType, 
        sms_free_sign_name: smsFreeSignName, 
        sms_template_code: smsTemplateCode, 
        sms_param: smsParam
    }

    result = bigfish.send_sms params
    self.result = result
  
    if JSON.parse(result).values[0]['result']['success'] == true
      self.sended_at = DateTime.now
      self.sended = true
    end

    self.save
  end

  def self.allow_send obj, type, seconds=60*60*24
    record = obj.dayus.of_type(type).order('sended_at desc').first
    if record
      return (record.sended_at - DateTime.now).abs > seconds
    else
      return true
    end
  end

  private
  def self.inheritance_column
    nil
  end

  def run2
    `
    php #{LaPath} dayu:send #{self.id}
    `
  end     
end