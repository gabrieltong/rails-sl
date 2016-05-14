class MembersController < ApplicationController
  layout 'wechat'

  wechat_api
  wechat_responder
  
  before_action :get_wechat_info

  def info

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
  end

  def money
  end

  def recover_password
  end

private
  def get_wechat_info_simple
    wechat_oauth2 'snsapi_userinfo' do |openid, info|
      logger.info openid
      logger.info info
    end
  end

  def get_wechat_info
    wechat_oauth2 'snsapi_userinfo' do |openid, info|
      # if openid.blank?
      #   redirect_to wechat_oauth2(request.original_url.gsub(/\?.*/, ''))
      # else
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
        if @wechat_user.member.nil?
          redirect_to bind_members_path
        end
      end
    end    
  end
end
