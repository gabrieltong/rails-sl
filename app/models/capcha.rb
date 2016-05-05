class Capcha < ActiveRecord::Base
	Validity = 60 * 10
	acts_as_paranoid

	scope :not_expired, ->{where(arel_table[:expired_at].gteq(DateTime.now))}
  scope :by_phone, ->(phone){where(:phone=>phone)}
  scope :by_type, ->(type){where(:type=>type)}
  scope :by_client, ->(client_id){where(:client_id=>client_id)}

	def self.allow_create obj, type
    record = obj.capchas.by_type(type).order('id desc').first
    if record
      return (record.created_at - DateTime.now).abs > Validity.seconds
    else
      return true
    end
  end

  def self.create_instance client_id, phone, type
    not_expired.by_client(client_id).by_type(type).by_phone(phone).destroy_all
    by_client(client_id).by_type(type).by_phone(phone).create! :expired_at=>DateTime.now+Validity.seconds, :code=>rand(100000..999999)
  end

  def self.inheritance_column
    nil
  end

  def self.validate_check_cards client_id, phone, card_tpl_id, number
    card_tpl = CardTpl.find(card_tpl_id)
    capcha = self.create_instance client_id, phone, __callee__

    config = {
      'type'=>__callee__,
      'smsType'=>'normal',
      'smsFreeSignName'=>'红券',
      'smsParam'=>{code: capcha.code.to_s, cardname: card_tpl.title, cardnumber: number.to_s},
      'recNum'=>phone,
      'smsTemplateCode'=>'SMS_8560750'
    }
  
    dy = Dayu.createByDayuable(card_tpl, config)
    dy.run
    dy.sended
  end

  def self.validate_group client_id, phone
  	client = Client.find(client_id)
    capcha = self.create_instance client_id, phone, __callee__

    config = {
      'type'=>__callee__,
      'smsType'=>'normal',
      'smsFreeSignName'=>'红券',
      'smsParam'=>{code: capcha.code.to_s, brand: client.title},
      'recNum'=>phone,
      'smsTemplateCode'=>'SMS_8480487'
    }
  
    dy = Dayu.createByDayuable(Member.first, config)
    dy.run
    dy.sended
  end

  def self.validate_spend_money client_id, phone, money
  	client = Client.find(client_id)
    capcha = self.create_instance client_id, phone, __callee__

    config = {
      'type'=>__callee__,
      'smsType'=>'normal',
      'smsFreeSignName'=>'红券',
      'smsParam'=>{code: capcha.code.to_s, brand: client.title, consumptionamount: money.to_s},
      'recNum'=>phone,
      'smsTemplateCode'=>'SMS_8515444'
    }
  
    dy = Dayu.createByDayuable(Member.first, config)
    dy.run
    dy.sended
  end

  def self.valid_code(client_id, phone, type, code)
  	instance = not_expired.by_client(client_id).by_phone(phone).by_type(type).order('id desc').first
  	if instance and instance.code == code
  		true
  	else
  		false
  	end
  end
  
end