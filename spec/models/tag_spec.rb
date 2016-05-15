require 'rails_helper'

RSpec.describe Tag, type: :model do
  it { is_expected.to have_attribute :name }

  it { is_expected.to have_and_belong_to_many :links }

  it { is_expected.to validate_presence_of :name }
end
