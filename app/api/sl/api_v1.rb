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

    class Activity < Grape::Entity
      format_with(:strftime) { |dt| dt.respond_to?(:strftime) ? dt.strftime("%F %T") : ''}
      # unexpose :updated_at
      expose :id
      expose :key
      expose :parameters
      with_options(format_with: :strftime) do
        expose :created_at
      end
    end

    class Card < Grape::Entity

    end

    class GroupMember < Grape::Entity
      format_with(:no_null) { |attr| attr.nil? ? '' : attr}
      with_options(format_with: :no_null) do
        expose :id
        expose :group_title
        expose :started_at
        expose :ended_at
        expose :phone
        expose :name
        expose :sex
        expose :borned_at
        expose :address
        expose :email
        expose :pic
        expose :money
      end
    end

    class ClientMember < Grape::Entity
      expose :id
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
      format_with(:strftime) { |dt| dt.respond_to?(:strftime) ? dt.strftime("%F %T") : ''}
      expose :id
      expose :title
      expose :short_desc
      expose :desc
      expose :intro
      expose :person_limit
      expose :cover_url do |record|
        record.cover_url(:medium)
      end
      expose :share_cover_url do |record|
        record.share_cover_url(:medium)
      end
      expose :guide_cover_url do |record|
        record.guide_cover_url(:medium)
      end
      expose :website
      expose :check_weeks
      expose :acquire_weeks
      with_options(format_with: :strftime) do
        expose :acquire_from
        expose :acquire_to
        expose :indate_from
        expose :indate_to
      end
      # expose :acquire_from do |record|
      #   record.acquire_from.strftime("%F %T")
      # end
      expose :member_cards_count
      expose :public
      expose :allow_share
      expose :total
      expose :remain
      expose :prediction
      expose :draw_type
      expose :check_hours
      expose :indate_type
      
      expose :indate_after
      expose :indate_today

      expose :acquired_count, if: lambda { |instance, options| options[:report] == true } do |instance, options|
        instance.cards.acquired_in_range(options[:from], options[:to]).size
      end

      expose :checked_count, if: lambda { |instance, options| options[:report] == true } do |instance, options|
        instance.cards.checked_in_range(options[:from], options[:to]).size
      end
    end		
  end

  class API_V1 < Grape::API
    version 'v1', using: :header, vendor: 'sl'
    format :json
    prefix :api

    helpers do
      def render
        @state ||= 'success'
        @error ||= ''
        @result ||= ''

        present :status, @state
        present :error, @error
        present :result, @result
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

      def login_helper
        @member = Member.includes(:managed_clients).where(:clients=>{:id=>params[:client_id]}).find_by_phone(params[:phone])
        if @member and @member.valid_password? params[:password]
          @result = @member
          @member.remember_me!
        else
          @error = ['no_user']
          @state = 'fail'
        end

        render
        present :result, @result, with: SL::Entities::Member if @result.is_a? Member
      end
    end

    resource :clients do

      params do
        requires :token, allow_blank: false, :type=>String
        requires :client_id, allow_blank: false, :type=>Integer
        optional :from, allow_blank: false, :type=>Date, :default=>(Date.today - 100.days)
        optional :to, allow_blank: false, :type=>Date, :default=>Date.today + 1.day
      end
      get :report do
        authenticate!
        authenticate_client_manager!
        render

        present :member_joined_count, current_client.group_members.where(GroupMember.arel_table[:created_at].gteq(params[:from])).where(GroupMember.arel_table[:created_at].lteq(params[:to])).size
        present :valided_joined_count, current_client.group_members.where(GroupMember.arel_table[:created_at].gteq(params[:from])).where(GroupMember.arel_table[:created_at].lteq(params[:to])).size
        present :charge_money, current_client.moneys.where(Money.arel_table[:created_at].gteq(params[:from])).where(Money.arel_table[:created_at].lteq(params[:to])).charge.sum(:money)
        present :spend_money, -current_client.moneys.where(Money.arel_table[:created_at].gteq(params[:from])).where(Money.arel_table[:created_at].lteq(params[:to])).spend.sum(:money)
        present :result, current_client.card_tpls, with: SL::Entities::CardTpl, :report=>true, :from=>params[:from], :to=>params[:to]
      end

      route_param :client_id do
        params do
          requires :client_id, allow_blank: false, :type=>Integer
        end
        get :setting do 
          render
          present :result, current_client.decorate.settings
        end
      end
    end

    resource :members do
      params do
        requires :phone, allow_blank: false, :type=>Integer
        requires :password, allow_blank: false, :type=>String
        requires :client_id, allow_blank: false, :type=>Integer
      end
      post :login do
        login_helper
      end
      get :login do
        login_helper
      end

      route_param :phone do
        params do
          requires :phone, allow_blank: false, :type=>Integer
        end
        get :send_capcha_bind_phone do
          render
          present :result, Capcha.send_capcha_bind_phone(params[:phone])
          render
        end

        params do
          requires :phone, allow_blank: false, :type=>Integer
        end
        get :send_capcha_recover_password do
          render
          member = Member.find_by_phone(params[:phone])
          if member
            present :result, Capcha.send_capcha_recover_password(nil, params[:phone])
          else
            :no_member
          end
        end

        params do
          requires :code, allow_blank: false, :type=>String
          requires :phone, allow_blank: false, :type=>Integer
          requires :password, allow_blank: false, :type=>String
        end
        get :change_password do
          render
          if Capcha.valid_code(nil , params[:phone], :send_capcha_recover_password, params[:code])
            member = Member.find_by_phone(params[:phone])
            if member
              member.password = params[:password]
              present :result, member.save
            else
              present :result, false
            end
          else
            present :result, false
          end
        end        

        desc '获取用户详情'
        params do
          requires :phone, allow_blank: false, :type=>Integer
          requires :token, allow_blank: false, :type=>String
          requires :client_id, allow_blank: false, :type=>Integer
        end
        get :info do
          authenticate!
          authenticate_client_manager!
          @client_member = current_client.client_members.by_phone(params[:phone]).first
          @group_members = current_client.group_members.includes(:group).by_phone(params[:phone])
          render
          present :result, @group_members, with: SL::Entities::GroupMember
        end
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
        present :result, CardTpl.unopen.sendable_by(current_member.phone), with: SL::Entities::CardTpl
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
        optional :phone, allow_blank: false, :type=>Integer, :default=>''
      end
      post :create do
        i = Image.new
        i.phone = params[:phone]
        i.file = params[:file]

        render
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
        render
        present :result, current_client.groups, with: SL::Entities::Group
      end

      desc '获取商户会员组列表'
      params do
        requires :token, allow_blank: false, :type=>String
        requires :client_id, allow_blank: false, :type=>Integer
        requires :phone, allow_blank: false, :type=>Integer
      end
      get :member_groups do
        authenticate!
        authenticate_client_manager!
        render
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
          gm = current_client.group_members.phone(params[:phone]).where(:group_id=>params[:group_id]).first || GroupMember.new
          render
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

          # requires :sex, allow_blank: false, :values=>['male','female']
          # requires :name, allow_blank: false, :type=>String
          # requires :borned_at, allow_blank: false, :type=>Date
          # requires :image_id, allow_blank: false, :type=>Integer
        end

        post :update_member_info do
          authenticate!
          authenticate_client_manager!
          cm_attributes = {:client_id=>params[:client_id], :sex=>params[:sex], :name=>params[:name], :borned_at=>params[:borned_at],:phone=>params[:phone]}
          cm = current_client.client_members.phone(params[:phone]).first

          if cm
            cm.update_attributes(cm_attributes)
          else
            cm = current_client.client_members.build(cm_attributes)
          end

          gm_attributes = {:group_id=>params[:group_id], :client_id=>params[:client_id], :started_at=>params[:started_at], :ended_at=>params[:ended_at], :phone=>params[:phone]}
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
            @result = true
            cm.pic = File.open(Image.find(params[:image_id]).file.path(:large)) if Image.exists?(params[:image_id])
            cm.save
            gm.save
          end
          render
        end
      end
    end
# TODO: 验证用户是否是 client 管理员
    resource :card_tpls do
      desc '用户拥有的卡卷列表'
      params do
        requires :client_id, allow_blank: false, :type=>Integer
        requires :token, allow_blank: false, :type=>String
        requires :phone, allow_blank: false, :type=>Integer
      end
      get :member_info do
        authenticate!
        authenticate_client_manager!

        cards = Card.acquired_by(params[:phone]).by_client(params[:client_id]).checkable.includes(:card_tpl)
        card_tpls = cards.collect {|card|card.card_tpl}.uniq
        card_tpls.each do |card_tpl|
          card_tpl.member_cards_count = cards.select {|card|card.card_tpl == card_tpl}.size
        end

        render
        present :result, card_tpls, with: SL::Entities::CardTpl
      end

      route_param :id do
        desc '卡卷能否核销'
        params do
          requires :id, allow_blank: false, :type=>Integer
          requires :client_id, allow_blank: false, :type=>Integer
          requires :phone, allow_blank: false, :type=>Integer
          requires :token, allow_blank: false, :type=>String
        end
        get :can_check do
          authenticate!
          authenticate_client_manager!

          card_tpl = CardTpl.find(params[:id])
          result = if card_tpl.can_check? != true
                    card_tpl.can_check?
                  elsif card_tpl.can_check_by_phone?(current_member.phone) != true
                    :by_phone_no_permission
                  else
                    true
                  end
          render
          present :result, result
          present :number, card_tpl.cards.acquired_by(params[:phone]).checkable.size
        end

        desc '核销多张卡密'
        params do
          requires :token, allow_blank: false, :type=>String
          requires :client_id, allow_blank: false, :type=>Integer
          requires :id, allow_blank: false, :type=>Integer
          requires :phone, allow_blank: false, :type=>Integer
          requires :number, allow_blank: false, :type=>Integer, :values=>(1..100)
        end
        get :check do
          authenticate!
          authenticate_client_manager!
          render
          present :result, CardTpl.find(params[:id]).check(params[:phone], current_member.phone, params[:number])
        end

        desc '是否能够发卷'
        params do
          requires :id, allow_blank: false, :type=>Integer
          requires :phone, allow_blank: false, :type=>Integer
          requires :token, allow_blank: false, :type=>String
        end
        get :can_acquire do
          authenticate!
          render
          can_send_by_phone = CardTpl.unopen.can_send_by_phone? params[:id], current_member.phone
          if can_send_by_phone === true
            present :result, CardTpl.unopen.can_acquire?(params[:id], params[:phone])
            present :number, [CardTpl.unopen.find(params[:id]).period_phone_can_acquire_count(params[:phone]), CardTpl.find(params[:id]).cards.acquirable.size].min
          else
            present :result, can_send_by_phone
          end
        end

        desc '发卷'
        params do
          requires :id, allow_blank: false, :type=>Integer
          requires :phone, allow_blank: false, :type=>Integer
          requires :token, allow_blank: false, :type=>String
          requires :number, allow_blank: false, :type=>Integer, :values=>(1..100)
        end
        get :acquire do
          authenticate!
          render
          present :result, CardTpl.unopen.acquire(params[:id], params[:phone], current_member.phone, params[:number])
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
        present :result, current_client.client_members.where(:phone=>params[:phone]).first.charge_money(params[:money], current_member.phone)
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
        present :result, current_client.client_members.where(:phone=>params[:phone]).first.spend_money(params[:money], current_member.phone)
      end
    end

    resource :capchas do
      params do
        requires :token, allow_blank: false, :type=>String
        requires :client_id, allow_blank: false, :type=>Integer
        requires :phone, allow_blank: false, :type=>Integer
        requires :type, allow_blank: false, :type=>String
        requires :code, allow_blank: false, :type=>String
      end
      get :valid_code do
        authenticate!
        authenticate_client_manager!
        render
        present :result, Capcha.valid_code(params[:client_id], params[:phone], params[:type], params[:code])
      end

      params do
        requires :token, allow_blank: false, :type=>String
        requires :client_id, allow_blank: false, :type=>Integer
        requires :phone, allow_blank: false, :type=>Integer
        requires :card_tpl_id, allow_blank: false, :type=>Integer
        requires :number, allow_blank: false, :type=>Integer, :values=>(0..1000)
      end
      get :validate_check_cards do
        authenticate!
        authenticate_client_manager!
        render
        present :result, Capcha.validate_check_cards(params[:client_id], params[:phone], params[:card_tpl_id], params[:number])
      end

      params do
        requires :token, allow_blank: false, :type=>String
        requires :client_id, allow_blank: false, :type=>Integer
        requires :phone, allow_blank: false, :type=>Integer
        requires :group_id, allow_blank: false, :type=>Integer
      end
      get :validate_group do
        authenticate!
        authenticate_client_manager!
        render
        present :result, Capcha.validate_group(params[:client_id], params[:phone])
      end

      params do
        requires :token, allow_blank: false, :type=>String
        requires :client_id, allow_blank: false, :type=>Integer
        requires :phone, allow_blank: false, :type=>Integer
        requires :money, allow_blank: false, :type=>Float
      end
      get :validate_spend_money do
        authenticate!
        authenticate_client_manager!
        render
        present :result, Capcha.validate_spend_money(params[:client_id], params[:phone], params[:money])
      end
    end

    resource :activities do
      params do
        requires :token, allow_blank: false, :type=>String
        requires :client_id, allow_blank: false, :type=>Integer
        optional :page, allow_blank: false, :type=>Integer, :default=>1
        optional :per_page, allow_blank: false, :type=>Integer, :default=>10, :values=>(1...100)
      end
      get :client_info do
        authenticate!
        authenticate_client_manager!
        render
        present :total_pages, current_client.activities.order('id desc').paginate(:page=>params[:page],:per_page=>params[:per_page]).total_pages
        present :result, current_client.activities.order('id desc').paginate(:page=>params[:page],:per_page=>params[:per_page]), with: SL::Entities::Activity
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
          if card 
            card_tpl = card.card_tpl
            render
            if current_member.checker_card_tpls.include? card_tpl
              present :result, card_tpl, with: SL::Entities::CardTpl
            end
          else
            @error = ['no_user']
            @state = 'fail'
          end
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
        end
        get :check do
          authenticate!
          render
          present :result, Card.check(params[:code], current_member.phone)
        end
      end
    end
  end
end
