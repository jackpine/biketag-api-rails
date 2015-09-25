require 'rails_helper'

describe 'spot requests' do
  describe 'POST /api/v1/spots' do
    context 'with a set up game' do
      before do
        require Rails.root + 'db/seeds.rb'
        Seeds.seed!
      end
      let(:previous_spot) { Spot.last }
      let(:image_data) { Base64.encode64(fake_file.read) }
      let(:new_spot_coordinates) { [-118.3240, 34.0937] }
      let(:user) { Seeds.user }
      let(:new_spot_parameters) do
        {
          spot: {
            game_id: Seeds.game.id,
            location: {
              type: 'Point',
              coordinates: new_spot_coordinates
            },
            image_data: image_data
          }
        }
      end

      it 'creates a new spot' do

        expect {
          post '/api/v1/spots', new_spot_parameters, Seeds.authorization_headers
        }.not_to change { user.reload.score }
        expect(response).to be_success

        actual_response = JSON.parse(response.body)
        expected_response = JSON.parse({
          spot:  {
            id: previous_spot.id,
            game_id: Seeds.game.id,
            guess_ids: [],
            url: "http://www.example.com/api/v1/spots/#{previous_spot.id}",
            location: {
              type: 'Point',
              coordinates: [-118.324, 34.0937]
            },
            user_id: user.id,
            user_name: user.name,
            image_url: sprintf('http://www.example.com/uploads/spots/images/000/000/%03d/large/%s.jpg', previous_spot.id, uuid_regex),
            created_at: previous_spot.created_at
          }
        }.to_json)

        # Image URL has to be checked separately
        expected_image_url = expected_response['spot'].delete('image_url')
        actual_image_url = actual_response['spot'].delete('image_url')

        expect(actual_response["spot"]).to eq(expected_response["spot"])

        actual_image_url_without_query_parameters = actual_image_url.split("?")[0]
        expected_image_url_without_query_parameters = expected_image_url.split("?")[0]
        expect(actual_image_url_without_query_parameters).to match(expected_image_url_without_query_parameters)
      end

      context 'when starting a new game' do
        let(:new_game_spot_parameters) { new_spot_parameters.tap {|p| p[:spot].delete(:game_id) } }

        it 'should charge the user for creating a new game' do
          expect {
            post '/api/v1/spots', new_game_spot_parameters, Seeds.authorization_headers
          }.to change { user.reload.score }.by(-25)
          expect(response).to be_success
        end
      end

      context 'when the new spot is too close to the old spot' do
        let(:new_spot_coordinates) { previous_spot.location['coordinates'] }

        it 'should fail to create the new spot' do
          post '/api/v1/spots', new_spot_parameters, Seeds.authorization_headers
          expect(response).not_to be_success
          expect(JSON.parse(response.body)['error']['message']).to include('farther')
        end
      end
    end
  end
end
