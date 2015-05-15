require 'rails_helper'

describe 'spot requests' do
  describe 'POST /api/v1/spots' do
    context 'with a set up game' do
      before do
        require Rails.root + 'db/seeds.rb'
        Seeds.seed!
      end
      let(:last_spot) { Spot.last }

      it 'creates a new spot' do

        image_data = Base64.encode64(File.read(Rails.root + 'db/seeds/images/952_lucile.jpg'))

        spot_parameters = {
          spot: {
            game_id: 1,
            location: {
              type: 'Point',
              coordinates: [-118.3240, 34.0937]
            },
            image_data: image_data
          }
        }

        post '/api/v1/spots', spot_parameters.merge(Seeds.auth_params)
        expect(response).to be_success

        actual_response = JSON.parse(response.body)
        uuid_regex = '\h{8}-\h{4}-\h{4}-\h{4}-\h{12}'
        expected_response = JSON.parse({
          spot:  {
            id: last_spot.id,
            game_id: 1,
            guess_ids: [],
            url: "http://www.example.com/api/v1/spots/#{last_spot.id}",
            location: {
              type: 'Point',
              coordinates: [-118.324, 34.0937]
            },
            user_id: 1, #TODO user system not implented yet.
            user_name: "michael", #TODO user system not implented yet.
            image_url: sprintf('http://www.example.com/uploads/spots/images/000/000/%03d/medium/%s.jpg', last_spot.id, uuid_regex),
            created_at: last_spot.created_at
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
    end
  end
end
