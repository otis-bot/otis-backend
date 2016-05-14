RSpec.describe SlackAuth do
  describe '#user' do
    it 'creates a user from the slack credentials' do
      auth_response = double(code: 200)

      allow(auth_response).to receive(:[])
        .with('user')
        .and_return('info')

      allow(auth_response).to receive(:[])
        .with('ok')
        .and_return(true)

      expect(SlackAuth).to receive(:get)
        .with(
          '/oauth.access',
          query: {
            code: 'SLACK_CODE',
            client_id: 'CLID',
            client_secret: 'SECRET'
          }
        )
        .and_return(auth_response)

      slack_auth = SlackAuth.new('SLACK_CODE', client_id: 'CLID', client_secret: 'SECRET')

      expect(slack_auth.user_info).to eq 'info'
    end

    it 'raises an error when code is invalid' do
      expect(SlackAuth).to receive(:get)
        .with(
          '/oauth.access',
          query: {
            code: 'SLACK_CODE',
            client_id: 'CLID',
            client_secret: 'SECRET'
          }
        )
        .and_return(double(code: 401))

      slack_auth = SlackAuth.new('SLACK_CODE', client_id: 'CLID', client_secret: 'SECRET')
      expect { slack_auth.user_info }.to raise_error(SlackAuth::APIError)
    end
  end
end
