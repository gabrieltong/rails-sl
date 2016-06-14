class ClientsController < ApplicationController
  layout 'wechat'

  wechat_api
  wechat_responder
  
  before_action :get_client, :get_wechat_info, :bind_phone

  def profile

  end

  def cards
    @cards = CardDecorator.decorate_collection(@member.acquired_cards.by_client(@client.id).includes(:card_tpl).order('id desc'))
  end

  def info

  end

  def permission

  end

  def bind
    if(!params[:phone].blank? and !params[:capcha].blank?)
      if Capcha.valid_code(nil, params[:phone], :send_capcha_bind_phone, params[:capcha])
        @wechat_user.phone = params[:phone]
        @wechat_user.save
        redirect_to bind_success_members_path
      else
        flash[:message] = '绑定失败'
      end
    end
  end

  def bind_success
    logger.info 
  end

  def money
  end

  def recover_password
    if request.post?
      if Capcha.valid_code(nil, params[:phone], :send_capcha_recover_password, params[:capcha])
        @member = @wechat_user.member
        @member.password = params[:password]
        @member.save
        redirect_to info_members_path
      else
        flash[:message] = '绑定失败'
      end
    end
  end

private
  def get_client
    @client = Client.find(params[:id])
  end
end
