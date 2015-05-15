require 'rails_helper'

describe 'api key requests' do
  describe 'POST /api/v1/api_keys' do
    context 'with a set up game' do
      before do
        require Rails.root + 'db/seeds.rb'
        Seeds.seed!
      end
      it 'returns the keys for a new user' do
        post '/api/v1/api_keys.json'
        expect(response).to be_success
        actual_response = JSON.parse(response.body)
        expect(actual_response['api_key']['client_id'].length).to eq(20)
        expect(actual_response['api_key']['secret'].length).to eq(20)
      end
    end
  end
end
