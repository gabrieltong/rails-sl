class CardTplsController < ApplicationController
  layout 'wechat'

  wechat_api
  wechat_responder

  before_action :get_wechat_info, :only=>[:acquire]
  before_action :get_instance, :only=>[:acquire]
  before_action :bind_phone_for_login, :only=>[:acquire]
  before_action :can_acquire, :only=>[:acquire]
  

  def acquire
    if CardTpl.login.exists? @card_tpl.id
      # bind_phone
    end
  end

private
  def can_acquire
    # @can_acquire = true
    @can_acquire = @card_tpl.can_acquire? @wechat_user.phone, :user
  end

  def get_instance
    @card_tpl = CardTpl.find(params[:id])
  end

  def bind_phone_for_login
    if @wechat_user.phone.blank? && CardTpl.login.exists?(@card_tpl.id)
      bind_phone
    end
  end
end
