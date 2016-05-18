require 'rails_helper'

RSpec.describe AuthToken do
  it 'encodes and decodes tokens' do
    token = AuthToken.encode(foo: 'bar')

    expect(AuthToken.decode(token)[:foo]).to eq 'bar'
  end
end
