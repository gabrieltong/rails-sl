module SL
  class API < Grape::API
  	version 'v1', using: :header, vendor: 'sl'
    format :json
    prefix :api

  	resource :members do
  		get :login do
	      @user = User.authenticate(params['username'],params['password'])

	      if @user
	        # @login_activity = @user.activities.where(:key=>'user.login').order('id desc').first
	        # @user.create_activity key: 'user.login', owner: @user
	      else
	        @error = ['no_user']
	        @status = 'fail'
	      end
  		end

  		get :all do
        Member.limit(10)
      end
  	end
  end
end
