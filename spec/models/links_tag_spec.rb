require 'rails_helper'

RSpec.describe LinksTag, type: :model do
  it { is_expected.to belong_to :link }
  it { is_expected.to belong_to :tag }
end
