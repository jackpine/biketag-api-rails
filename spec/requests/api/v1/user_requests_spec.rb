require 'rails_helper'

describe 'user requests' do
  describe 'GET /api/v1/users/1' do
    context 'with a set up game' do
      before do
        require Rails.root + 'db/seeds.rb'
        Seeds.seed!
      end

      it 'should return details about the user' do
        user_id = Seeds.user.id
        get "/api/v1/users/#{user_id}.json", nil, Seeds.authorization_headers
        expect(response).to be_success

        actual_response = JSON.parse(response.body)
        expected_response = JSON.parse({
          user: {
            id: user_id,
            name: 'First User',
            score: 50
          }
        }.to_json)

        expect(actual_response).to eq(expected_response)
      end
    end
  end
end

