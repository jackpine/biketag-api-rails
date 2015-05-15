require 'rails_helper'

describe 'guess requests' do
  describe 'POST /api/v1/guesses' do
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
              spot_id: spot_id,
              location: {
                type: 'Point',
                coordinates: [-118.2816, 34.0865]
              }
            }
          }
        end
        it 'returns a positive result' do
          post '/api/v1/guesses', guess_params.merge(Seeds.auth_params)
          expect(response).to be_success

          actual_response = JSON.parse(response.body)
          expect(actual_response['guess']['correct']).to eq(true)
        end
      end

      context 'with an incorrect guess' do
        let(:guess_params) do
          {
            guess: {
              spot_id: spot_id,
              location: {
                type: 'Point',
                coordinates: [-117.3240, 33.0937]
              }
            }
          }
        end
        it 'returns a negative result' do
          post '/api/v1/guesses', guess_params.merge(Seeds.auth_params)
          expect(response).to be_success

          actual_response = JSON.parse(response.body)
          expect(actual_response['guess']['correct']).to eq(false)
        end
      end
    end
  end
end




