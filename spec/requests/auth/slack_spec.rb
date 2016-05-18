require 'rails_helper'

RSpec.describe Auth::Slack do
  describe 'POST /api/v1/auth/slack' do
    it 'returns an auth token' do
      auth_double = instance_double(
        SlackAuth,
        user_info: {
          'name' => 'John Doe',
          'email' => 'foo@bar.com'
        }
      )

      expect(SlackAuth).to receive(:new).with('AUTH_CODE').and_return(auth_double)

      expect(AuthToken).to receive(:encode)
        .and_return('AUTH_TOKEN')

      post '/api/v1/auth/slack', code: 'AUTH_CODE'

      expect(response.code).to eq '201'
      expect(JSON.parse(response.body)['auth_token']).to eq 'AUTH_TOKEN'
      expect(User.count).to eq 1
    end
  end
end
