class CardTplsController < ApplicationController
  layout 'wechat'

  wechat_api
  wechat_responder

  before_action :get_instance, :only=>[:acquire]
  # before_action :get_wechat_info, :only=>[:acquire]

  def acquire
    if CardTpl.login.exists? @card_tpl.id
      # bind_phone
    end
  end

private
  def get_instance
    @card_tpl = CardTpl.find(params[:id])
  end
end
