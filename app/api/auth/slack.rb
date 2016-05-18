class Auth::Slack < Grape::API
  namespace :auth do
    params do
      requires :code, desc: 'Oauth code from slack'
    end
    post :slack do
      authenticator = SlackAuth.new(params[:code])

      user = User.from_slack(authenticator.user_info)
      user.save

      { auth_token: user.auth_token }
    end
  end
end
