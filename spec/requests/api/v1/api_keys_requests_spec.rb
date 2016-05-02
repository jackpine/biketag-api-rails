require 'rails_helper'

describe 'api key requests' do
  describe 'POST /api/v1/api_keys' do
    it 'returns the keys for a new user' do
      post '/api/v1/api_keys.json'
      expect(response).to be_success
      actual_response = JSON.parse(response.body)
      expect(actual_response['api_key']['client_id'].length).to eq(20)
      expect(actual_response['api_key']['secret'].length).to eq(20)
    end
  end
end

describe 'authorization' do
  it 'authorized requests responds without error' do
    get "/api/v1/games/#{Seeds.game.id}/current_spot.json", nil, authorization_headers_for_user(Seeds.user)
    expect(response).to be_success
  end
  it 'unauthorized requests responds with a JSON error' do
    get '/api/v1/games/1/current_spot.json'
    expect(response).to_not be_success
    expect(JSON.parse(response.body)).to have_key('error')
  end
end
