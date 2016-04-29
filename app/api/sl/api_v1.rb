module SL
  module Entities
    class Image < Grape::Entity
      expose :id
      expose :file_url do |record|
        record.file_url(:medium)
      end
    end

    class Group < Grape::Entity
      expose :id
      expose :title
      expose :default
      expose :position
      expose :desc
    end

    class GroupMember < Grape::Entity
      expose :id
      expose :started_at
      expose :ended_at
      expose :phone
      expose :name
      expose :sex
      expose :borned_at
      expose :address
      expose :email
      expose :pic
    end

    class Member < Grape::Entity
      expose :id
      expose :remember_token
      expose :phone
    end

    class CardTpl < Grape::Entity
      expose :id
      expose :title
      expose :short_desc
      expose :desc
      expose :intro
      expose :cover_url do |record|
        record.cover_url(:medium)
      end
      expose :person_limit
      expose :share_cover_url do |record|
        record.share_cover_url(:medium)
      end
      expose :guide_cover_url do |record|
        record.guide_cover_url(:medium)
      end
      expose :website
      expose :check_weeks
      expose :acquire_weeks
      expose :acquire_from
      expose :acquire_to
      expose :public
      expose :allow_share
      expose :total
      expose :remain
      expose :prediction
      expose :draw_type
      expose :check_hours
      expose :indate_type
      expose :indate_from
      expose :indate_to
      expose :indate_after
      expose :indate_today
    end		
  end

  class API_V1 < Grape::API
    version 'v1', using: :header, vendor: 'sl'
    format :json
    prefix :api

    helpers do
      def render
        @status ||= 'success'
        present :status, @status
      end

      def current_member
        @current_member ||= Member.find_by_remember_token(params[:token])
      end

      def current_client
        @current_client ||= Client.find_by_id(params[:client_id])
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless current_member
      end

      def authenticate_client_manager!
        error!('401 Unauthorized', 401) unless current_client
      end
    end

    resource :members do
      params do
        requires :phone, allow_blank: false, :type=>Integer
        requires :password, allow_blank: false, :type=>String
        requires :client_id, allow_blank: false, :type=>Integer
      end
      get :login do
        @member = Member.includes(:managed_clients).where(:clients=>{:id=>params[:client_id]}).find_by_phone(params[:phone])
        if @member and @member.valid_password? params[:password]
          @result = @member
        else
          @error = ['no_user']
          @status = 'fail'
        end

        if @result.is_a? Member
          present :result, @result, with: SL::Entities::Member
        else
          present :result, ''
        end
        render
      end
    end

    resource :card_tpls do
      params do
        requires :token, allow_blank: false, :type=>String
      end
      desc '能够发送的卡卷'
      get :sendable_by do
        authenticate!
        render
        present :result, CardTpl.sendable_by(current_member.phone), with: SL::Entities::CardTpl
      end

      params do
        requires :token, allow_blank: false, :type=>String
      end
      desc '能够核销的卡卷'
      params do
        requires :token, allow_blank: false, :type=>String
      end
      get :checkable_by do
        authenticate!
        render
        present :result, CardTpl.checkable_by(current_member.phone), with: SL::Entities::CardTpl
      end

      route_param :id do
        desc '卡卷报表信息'
        params do
          requires :token, allow_blank: false, :type=>String
          requires :date, allow_blank: false, :type=>Date
          requires :id, allow_blank: false, :type=>Integer
        end
        get 'report/:date' do
          Status.find(params[:id])
        end
      end
    end

    resource :images do
      params do
        # requires :token, allow_blank: false, :type=>String
        optional :phone, allow_blank: false, :type=>Integer, :default=>13654265306
      end
      post :create do
        # authenticate!
        i = Image.new
        i.phone = params[:phone]
        i.file = params[:image_file].tempfile
        if i.save
          present :result, i, with: SL::Entities::Image
        else
          present :error, i.errors
        end
      end
    end

    resource :groups do 
      desc '获取商户会员组列表'
      params do
        requires :token, allow_blank: false, :type=>String
        requires :client_id, allow_blank: false, :type=>Integer
      end
      get :all do
        authenticate!
        authenticate_client_manager!
        present :result, current_client.groups, with: SL::Entities::Group
      end

      route_param :group_id do 
        desc '获取某会员在该会员组详情详情'
        params do
          requires :group_id, allow_blank: false, :type=>Integer, :desc=>'会员组ID'
          requires :token, allow_blank: false, :type=>String
          requires :client_id, allow_blank: false, :type=>Integer
        end
        get :member_info do
          authenticate!
          authenticate_client_manager!
          gm = current_client.group_members.phone(params[:phone]).first
          present :result, gm, with: SL::Entities::GroupMember
        end

        desc '更新群组信息'
        params do
          requires :token, allow_blank: false, :type=>String
          requires :client_id, allow_blank: false, :type=>Integer
          requires :phone, allow_blank: false, :type=>Integer
          requires :group_id, allow_blank: false, :type=>Integer

          requires :started_at, allow_blank: false, :type=>Date
          requires :ended_at, allow_blank: false, :type=>Date

          requires :sex, allow_blank: false, :values=>['male','female']
          requires :name, allow_blank: false, :type=>String
          requires :borned_at, allow_blank: false, :type=>Date
        end

        post :update_member_info do
          authenticate!
          authenticate_client_manager!
          cm_attributes = {:sex=>params[:sex], :name=>params[:name], :borned_at=>params[:borned_at],:phone=>params[:phone]}
          cm = current_client.client_members.phone(params[:phone]).first

          if cm
            cm.update_attributes(cm_attributes)
          else
            cm = current_client.client_members.build(cm_attributes)
          end

          gm_attributes = {:started_at=>params[:started_at], :ended_at=>params[:ended_at], :phone=>params[:phone]}
          gm = current_client.group_members.phone(params[:phone]).first
          if gm
            gm.update_attributes(gm_attributes)
          else
            gm = current_client.group_members.build(gm_attributes)
          end

          if !cm.valid?
            present :error, cm.errors
          elsif !gm.valid?
            present :error, gm.errors
          else
            cm.save
            gm.save
            render
          end
        end
      end
    end

    resource :card_tpls do
      route_param :id do
        desc '是否能够发卷'
        params do
          requires :id, allow_blank: false, :type=>Integer
          requires :phone, allow_blank: false, :type=>Integer
          requires :token, allow_blank: false, :type=>String
        end
        get :can_acquire do
          authenticate!
          render
          can_send_by_phone = CardTpl.can_send_by_phone? params[:id], current_member.phone
          if can_send_by_phone === true
            present :result, CardTpl.can_acquire?(params[:id], params[:phone])
          else
            present :result, can_send_by_phone
          end
        end

        desc '发卷'
        params do
          requires :id, allow_blank: false, :type=>Integer
          requires :phone, allow_blank: false, :type=>Integer
          requires :token, allow_blank: false, :type=>String
          # requires :number, allow_blank: false, :type=>Integer, :values=>(1..1)
        end
        get :acquire do
          authenticate!
          render
          present :result, CardTpl.acquire(params[:id], params[:phone], current_member.phone)
        end
      end
    end

    resource :money do
      desc '给用户充值'
      params do
        requires :token, allow_blank: false, :type=>String
        requires :phone, allow_blank: false, :type=>Integer
        requires :client_id, allow_blank: false, :type=>Integer
        requires :money, allow_blank: false, :type=>Integer, :values=>(0..1000)
      end
      get :charge do
        authenticate!
        authenticate_client_manager!
        render
        present :result, current_member.client_members.where(:phone=>params[:phone]).first.charge_money(params[:money], current_member.phone)
      end

      desc '消费'
      params do
        requires :token, allow_blank: false, :type=>String
        requires :phone, allow_blank: false, :type=>Integer
        requires :client_id, allow_blank: false, :type=>Integer
        requires :money, allow_blank: false, :type=>Integer, :values=>(0..1000)
      end
      get :spend do
        authenticate!
        authenticate_client_manager!
        render
        present :result, current_member.client_members.where(:phone=>params[:phone]).first.charge_money(params[:money], current_member.phone)
      end
    end

    resource :cards do
      route_param :code do
        desc '发送核销验证码'
        params do
          requires :code, allow_blank: false, :type=>Integer
          # requires :token, allow_blank: false, :type=>String
        end
        get :send_check_capcha do
          # authenticate!
          render
          card = Card.find_by_code(params[:code])
          present :result, card.send_check_capcha
        end

        desc '核销前获取卡卷信息'
        params do
          requires :code, allow_blank: false, :type=>Integer
          requires :token, allow_blank: false, :type=>String
        end
        get :card_info do
          authenticate!
          card = Card.includes(:card_tpl).find_by_code(params[:code].to_s)
          card_tpl = card.card_tpl

          if current_member.checker_card_tpls.include? card_tpl
            present :result, card_tpl, with: SL::Entities::CardTpl
          end
          # present :result, ''
        end

        # 卡能否可笑
        # 卡卷能否核销
        # 用户是否有核销权限
        desc '卡卷能否核销'
        params do
          requires :code, allow_blank: false, :type=>Integer
          requires :token, allow_blank: false, :type=>String
        end
        get :can_check do
          authenticate!
          render
          can_check_by_phone = Card.can_check_by_phone? params[:code], current_member.phone
          if can_check_by_phone === true
            present :result, Card.can_check?(params[:code])
          else
            present :result, can_check_by_phone
          end
        end

        desc '核销卡卷'
        params do
          requires :token, allow_blank: false, :type=>String
          requires :code, allow_blank: false, :type=>Integer
          requires :capcha, allow_blank: false, :type=>String
        end
        get :check do
          authenticate!
          render
          present :result, Card.check(params[:code], params[:capcha], current_member.phone)
        end
      end
    end
  end
end
