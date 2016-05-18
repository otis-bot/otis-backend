class SlackAuth
  include HTTParty
  base_uri 'https://slack.com/api'

  attr_accessor :access_code, :client_id, :client_secret

  def initialize(code, client_id: ENV.fetch('SLACK_CLIENT_ID'), client_secret: ENV.fetch('SLACK_CLIENT_SECRET'))
    self.access_code = code
    self.client_id = client_id
    self.client_secret = client_secret
  end

  def user_info
    auth_response = self.class.get(
      '/oauth.access',
      query: {
        code: access_code,
        client_id: client_id,
        client_secret: client_secret
      }
    )

    raise APIError, 'Failed to retrieve token' unless auth_response.code == 200 && auth_response['ok']

    auth_response['user']
  end

  class APIError < StandardError
  end
end
