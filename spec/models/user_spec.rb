require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_attribute :first_name }
  it { is_expected.to have_attribute :last_name }
  it { is_expected.to have_attribute :username }
  it { is_expected.to have_attribute :email }

  it { is_expected.to validate_presence_of :username }
  it { is_expected.to validate_presence_of :email }
end
