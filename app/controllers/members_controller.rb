class MembersController < ApplicationController
  layout 'wechat'

  wechat_api
  wechat_responder
  
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
end
