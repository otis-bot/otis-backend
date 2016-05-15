require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_attribute :name }
  it { is_expected.to have_attribute :username }
  it { is_expected.to have_attribute :email }

  it { is_expected.to validate_presence_of :email }

  describe '.from_slack' do
    it 'creates a user from the slack info hash' do
      user = User.from_slack('name' => 'John Doe', 'email' => 'jdoe@example.com')

      expect(user.name).to eq 'John Doe'
      expect(user.email).to eq 'jdoe@example.com'
    end

    it 'returns and updates an existing user, if available' do
      db_user = create(:user)

      updated_user = User.from_slack('name' => 'Mr NameChanger', 'email' => db_user.email)

      expect(updated_user.name).to eq 'Mr NameChanger'
      expect(db_user.id).to eq updated_user.id
    end
  end

  describe '.auth_token' do
    it 'returns a JWT token with the user id' do
      user = build(:user, id: 1)

      expect(AuthToken).to receive(:encode)
        .with(user_id: 1)
        .and_return('TOKEN')

      token = user.auth_token

      expect(token).to eq 'TOKEN'
    end
  end
end
