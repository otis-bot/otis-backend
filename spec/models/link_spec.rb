require 'rails_helper'

RSpec.describe Link, type: :model do
  it { is_expected.to have_attribute :uri }
  it { is_expected.to have_attribute :upvote_count }
  it { is_expected.to have_attribute :downvote_count }

  it { is_expected.to have_many :comments }
  it { is_expected.to have_many(:tags).through(:links_tags) }

  it { is_expected.to validate_presence_of :uri }
end
