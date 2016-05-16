class ClientsController < ApplicationController
  layout 'wechat'

  wechat_api
  wechat_responder
  
  before_action :get_client, :get_wechat_info

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

  def get_wechat_info_simple
    wechat_oauth2 'snsapi_userinfo' do |openid, info|
      logger.info openid
      logger.info info
    end
  end

  def get_wechat_info
    # @wechat_user = WechatUser.find_by_phone(13654265306)
    # @member = @wechat_user.member
    # @client_member = @member.client_members.where(:phone=>@member.phone).first.decorate
    # return

    wechat_oauth2 do |openid, info|
      logger.info "openid: #{openid}"
      if openid
        wechat_user = WechatUser.find_by_openid(openid)
        if wechat_user.blank?
          wechat_user = WechatUser.new(info)
          wechat_user.save
        end

        @wechat_user = wechat_user
        @member = wechat_user.member
        if @wechat_user.member.nil? && !(request.original_url.include?(bind_members_path))
          redirect_to bind_members_path
        end
        logger.info @wechat_user
      end
    end    
  end

  def get_wechat_info_snsapi
    wechat_oauth2 'snsapi_userinfo' do |openid, info|
      logger.info "openid: #{openid}"
      if openid
        info ||= {}
        if info['access_token']
          info = info.merge!(wechat.web_userinfo(info['access_token'], openid))
        end
        info.compact!

        wechat_user = WechatUser.find_by_openid(openid)
        if wechat_user
          wechat_user.update_attributes info
        else
          wechat_user = WechatUser.new(info)
          wechat_user.save
        end
        @wechat_user = wechat_user
        

        if @wechat_user.member.nil? && !(request.original_url.include?(bind_members_path))
          redirect_to bind_members_path
        else
          @member = wechat_user.member
          @client_member = @member.client_members.where(:phone=>@member.phone).first.decorate
        end
        
        logger.info @wechat_user
      end
    end    
  end
end
