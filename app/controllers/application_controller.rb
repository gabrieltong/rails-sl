class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # 根据分页的数量
  # require @page
  # require @per_page
  # set @collection
  def paginate(collection)
    collection.paginate(:page=>@page,:per_page=>@per_page)
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
        @member = @wechat_user.member
      end
    end
  end

  def bind_phone
    if @wechat_user.phone.nil? && !(request.original_url.include?(bind_members_path))
      redirect_to bind_members_path
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
