require 'rails_helper'

describe 'guess requests' do
  describe 'POST /api/v1/guesses' do
    context 'with a set up game' do
      before do
        require Rails.root + 'db/seeds.rb'
        Seeds.seed!
      end
      let(:spot_id) { Seeds.lucile_spot.id }
      let(:image_data) { Base64.encode64(fake_file.read) }

      context 'with a correct guess' do
        let(:guess_params) do
          {
            guess: {
              spot_id: spot_id,
              image_data: image_data,
              location: {
                type: 'Point',
                coordinates: [-118.2816, 34.0865]
              }
            }
          }
        end
        it 'returns a positive result' do
          post '/api/v1/guesses', guess_params, authorization_headers_for_user(Seeds.user)
          expect(response).to be_success

          actual_response = JSON.parse(response.body)
          expect(actual_response['guess']['correct']).to eq(true)

          # Image URL has to be checked separately
          expected_image_url = sprintf('http://www.example.com/uploads/guesses/images/000/000/%03d/medium/%s.jpg', Guess.last.id, uuid_regex)
          actual_image_url = actual_response['guess'].delete('image_url')
          actual_image_url_without_query_parameters = actual_image_url.split("?")[0]
          expected_image_url_without_query_parameters = expected_image_url.split("?")[0]
          expect(actual_image_url_without_query_parameters).to match(expected_image_url_without_query_parameters)
        end
        it 'adds to the users score' do
          expect {
            post '/api/v1/guesses', guess_params, authorization_headers_for_user(Seeds.user)
          }.to change { Seeds.user.reload.score }.by(10)
        end
      end

      context 'with an incorrect guess' do
        let(:guess_params) do
          {
            guess: {
              spot_id: spot_id,
              image_data: image_data,
              location: {
                type: 'Point',
                coordinates: [-117.3240, 33.0937]
              }
            }
          }
        end
        it 'returns a negative result' do
          post '/api/v1/guesses', guess_params, authorization_headers_for_user(Seeds.user)
          expect(response).to be_success

          actual_response = JSON.parse(response.body)
          expect(actual_response['guess']['correct']).to eq(false)
        end

        it 'does not add to the users score' do
          expect {
            post '/api/v1/guesses', guess_params, authorization_headers_for_user(Seeds.user)
          }.not_to change { Seeds.user.reload.score }
        end
      end
    end
  end
end




