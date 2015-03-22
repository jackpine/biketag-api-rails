require 'rails_helper'

describe 'guess requests' do
  describe 'POST /api/v1/games/1/spots/2/guesses' do
    context 'with a set up game' do
      before do
        require Rails.root + 'db/seeds.rb'
        Seeds.seed!
      end
      let(:spot_id) { Seeds.lucile_spot.id }

      context 'with a correct guess' do
        let(:guess_params) do
          {
            guess: {
              location: {
                latitude: 34.0937,
                longitude: -118.3240
              }
            }
          }
        end
        it 'returns the current spot' do
          post "/api/v1/games/1/spots/#{spot_id}/guesses.json", guess_params
          expect(response).to be_success

          actual_response = JSON.parse(response.body)
          expect(actual_response['guess']['result']).to be_true
        end
      end

      context 'with an incorrect guess' do
        let(:guess_params) do
          {
            guess: {
              location: {
                latitude: '123.45',
                longitude: '-189.12'
              }
            }
          }
        end
        it 'returns the current spot' do
          post "/api/v1/games/1/spots/#{spot_id}/guesses.json", guess_params
          expect(response).to be_success

          actual_response = JSON.parse(response.body)
          expect(actual_response['guess']['result']).to be_false
        end
      end
    end
  end
end




