module SL
  module Entities
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
      expose :cover_url
      expose :person_limit
      expose :share_cover_url
      expose :guide_cover_url
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

      def authenticate!
        error!('401 Unauthorized', 401) unless current_member
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
      get :sender do
        authenticate!
        render
        present :result, current_member.sender_card_tpls, with: SL::Entities::CardTpl
      end

      params do
        requires :token, allow_blank: false, :type=>String
      end
      desc '能够核销的卡卷'
      params do
        requires :token, allow_blank: false, :type=>String
      end
      get :checker do
        authenticate!
        render
        present :result, current_member.checker_card_tpls, with: SL::Entities::CardTpl
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
          if CardTpl.can_send_by_member? params[:id], current_member
            present :result, CardTpl.can_acquire?(params[:id], params[:phone])
          else
            present :result, :no_record
          end
        end

        desc '发卷'
        params do
          requires :id, allow_blank: false, :type=>Integer
          requires :phone, allow_blank: false, :type=>Integer
          requires :token, allow_blank: false, :type=>String
          requires :number, allow_blank: false, :type=>Integer, :values=>(1..1)
        end
        get :acquire do
          authenticate!
          render
          present :result, CardTpl.acquire(params[:id], params[:phone], current_member, params[:number])
        end
      end
    end

    resource :cards do
      route_param :code do
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
          if Card.can_check_by_member? params[:code], current_member
            present :result, Card.can_check?(params[:code])
          else
            present :result, :no_record
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
          present :result, Card.check(params[:code], params[:capcha], current_member)
        end
      end
    end
  end
end
