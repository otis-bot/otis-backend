require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { is_expected.to have_attribute :body }
  it { is_expected.to have_attribute :link_id }

  it { is_expected.to belong_to :link }

  it { is_expected.to validate_presence_of :body }
end
