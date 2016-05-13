class MembersController < ApplicationController
  layout 'wechat'

  wechat_api
  wechat_responder
  
  before_action :get_wechat_info

  def info

  end

  def bind
  end

  def bind_success
  end

  def money
  end

  def recover_password
  end

private
  def get_wechat_info
    wechat_oauth2 'snsapi_userinfo' do |openid, info|
      if openid.nil?
        redirect_to wechat_oauth2('snsapi_userinfo')
      else
        openid = 'okW-muCpiUP65GENPmA0-Fn9TXjE'
        if info['access_token']
          info = info.merge!(wechat.web_userinfo(info['access_token'], openid))
        end
        # info = {"openid"=>"okW-muCpiUP65GENPmA0-Fn9TXjE", "nickname"=>"Olivia", "sex"=>2, "language"=>"zh_CN", "city"=>"大连", "province"=>"辽宁", "country"=>"中国", "headimgurl"=>"http://wx.qlogo.cn/mmopen/QFFogGRZx7nrPda26nFAU8TUQmJUBLpLd4iaNSzmiaznZEUlEPhAmybE1d4m2Nmj3fsTaEdiceGabJWSK7rnMB4KCnOSLFyPgPF/0", "privilege"=>[], "unionid"=>"oE7u5t7qA04FXQiuyPZ9jKwLgatE"}
        wechat_user = WechatUser.find_by_openid(openid)
        if wechat_user
          wechat_user.update_attributes info
        else
          wechat_user = WechatUser.new(info)
          wechat_user.save
        end
      end
    end    
  end
end
