require 'rails_helper'

describe 'spots requests' do
  describe 'GET /api/v1/games/1/current_spot' do
    context 'with a spot' do
      before do
        load Rails.root + 'db/seeds.rb'
      end

      it 'returns the current spot' do

        get '/api/v1/games/1/current_spot.json'
        expect(response).to be_success

        actual_response = JSON.parse(response.body)

        expected_response = JSON.parse({
          spot:  {
            id: 1,
            url: 'http://www.example.com/api/v1/games/1/spot/1.json',
            #user_id: 456, #TODO not implented yet.
            image_url: '/images/medium/missing.png', #TODO implement photo upload
            created_at: spot.created_at
          }
        }.to_json)

        expect(actual_response["spot"]).to eq(expected_response["spot"])
      end
    end
  end
end
