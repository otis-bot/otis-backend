class User < ActiveRecord::Base
  validates :email, presence: true

  def self.from_slack(info_hash)
    user = find_or_initialize_by(email: info_hash['email'])

    user.name = info_hash['name']

    user
  end

  def auth_token
    AuthToken.encode(user_id: id)
  end
end
