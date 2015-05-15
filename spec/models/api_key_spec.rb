require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  let(:api_key) { ApiKey.new }
  describe "#ensure_authentication_tokens" do
    it 'generates client_id and secret on initialize' do
      expect(api_key.client_id.length).to eq(20)
      expect(api_key.secret.length).to eq(20)
    end
  end

end
