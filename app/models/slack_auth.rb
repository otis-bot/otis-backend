class SlackAuth
  include HTTParty
  base_uri 'https://slack.com/api'

  attr_accessor :access_code, :client_id, :client_secret, :access_token, :slack_user_id

  def initialize(code, client_id: ENV.fetch('SLACK_CLIENT_ID'), client_secret: ENV.fetch('SLACK_CLIENT_SECRET'))
    self.access_code = code
    self.client_id = client_id
    self.client_secret = client_secret
    retrieve_access_token
  end

  def user_info
    response = self.class.get(
      '/users.info',
      query: {
        token: access_token,
        user: slack_user_id
      }
    )

    raise APIError, 'Failed to get user info' unless response.code == 200 && response['ok']

    response['user']
  end

  private

  def retrieve_access_token
    auth_response = self.class.get(
      '/oauth.access',
      query: {
        code: access_code,
        client_id: client_id,
        client_secret: client_secret
      }
    )

    raise APIError, 'Failed to retrieve token' unless auth_response.code == 200 && auth_response['ok']

    self.access_token = auth_response['access_token']
    self.slack_user_id = auth_response['user_id']
  end

  class APIError < StandardError
  end
end
