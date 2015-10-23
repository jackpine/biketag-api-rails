require 'rails_helper'

describe 'game requests' do
  context 'with a set up game' do
    before do
      require Rails.root + 'db/seeds.rb'
      Seeds.seed!
    end
    let(:last_spot_id) { Spot.last.id }

    describe 'GET /api/v1/games/current_spots.json' do
      it 'returns all the games current spots' do
        get '/api/v1/games/current_spots.json', nil, authorization_headers_for_user(Seeds.user)
        expect(response).to be_success

        actual_response = JSON.parse(response.body)
        expected_response = JSON.parse({
          spots: [
            { game_id: Seeds.game.id,
              guess_ids: [],
              id: last_spot_id,
              url: "http://www.example.com/api/v1/spots/#{last_spot_id}",
              user_id: Seeds.user.id,
              user_name: Seeds.user.name,
              location: {"type"=>"Point", "coordinates"=>[-118.281617, 34.086588]},
              image_url: sprintf('http://www.example.com/uploads/spots/images/000/000/%03d/large/952_lucile.jpg?1426555184', last_spot_id),
              created_at: Seeds.lucile_spot.created_at
            }
          ]
        }.to_json)

        expect(actual_response).to be_a(Hash)
        expect(actual_response).to have_key('spots')
        expect(actual_response['spots']).to be_an(Array)

        # Image URL has to be checked separately
        expected_image_url = expected_response['spots'][0].delete('image_url')
        actual_image_url = actual_response['spots'][0].delete('image_url')
        expect(actual_response).to eq(expected_response)

        actual_image_url_without_query_parameters = actual_image_url.split("?")[0]
        expected_image_url_without_query_parameters = expected_image_url.split("?")[0]
        expect(actual_image_url_without_query_parameters).to match(expected_image_url_without_query_parameters)
      end
    end

    describe 'GET /api/v1/games' do
      it 'returns all the games' do
        get '/api/v1/games.json', nil, authorization_headers_for_user(Seeds.user)
        expect(response).to be_success

        actual_response = JSON.parse(response.body)

        expected_response = JSON.parse({
          games: [
            { id: Seeds.game.id,
              name: Seeds.game.name,
              created_at: Seeds.game.created_at,
              current_spot_id: last_spot_id,
              spot_ids: Seeds.game.spot_ids
            }
          ]
        }.to_json)

        expect(actual_response).to be_a(Hash)
        expect(actual_response).to have_key("games")
        expect(actual_response["games"]).to be_an(Array)
        expect(actual_response["games"]).to eq(expected_response["games"])
      end
    end

    describe 'GET /api/v1/games/1/current_spot' do
      it 'returns the current spot' do
        get "/api/v1/games/#{Seeds.game.id}/current_spot.json", nil, authorization_headers_for_user(Seeds.user)
        expect(response).to be_success

        actual_response = JSON.parse(response.body)

        expected_response = JSON.parse({
          spot:  {
            game_id: Seeds.game.id,
            guess_ids: [],
            id: last_spot_id,
            url: "http://www.example.com/api/v1/spots/#{last_spot_id}",
            user_id: Seeds.user.id,
            user_name: Seeds.user.name,
            location: {"type"=>"Point", "coordinates"=>[-118.281617, 34.086588]},
            image_url: sprintf('http://www.example.com/uploads/spots/images/000/000/%03d/large/952_lucile.jpg?1426555184', last_spot_id),
            created_at: Seeds.lucile_spot.created_at
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
