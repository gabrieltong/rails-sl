class MembersController < ApplicationController
  layout 'wechat'

  wechat_api
  wechat_responder
  
  def info
    wechat_oauth2 'snsapi_userinfo' do |openid, info|
      logger.info '...............'
      logger.info openid
      logger.info info
      # @current_user = User.find_by(wechat_openid: openid)
      # @articles = @current_user.articles
    end    
  end

  def bind
  end

  def bind_success
  end

  def money
  end

  def recover_password
  end
end
