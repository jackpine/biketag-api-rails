require 'rails_helper'

describe 'user requests' do
  context 'with a set up game' do
    before do
      require Rails.root + 'db/seeds.rb'
      Seeds.seed!
    end
    let(:first_user) { Seeds.user }
    let(:first_users_spot) { Seeds.lucile_spot }

    describe 'GET /api/v1/users' do
      let!(:second_user) { User.create_for_game!(name: 'Second User') }
      it 'should return an array of users' do
        get '/api/v1/users.json', nil, authorization_headers_for_user(Seeds.user)
        expect(response).to be_success

        actual_response = JSON.parse(response.body)
        expected_response = JSON.parse({
          users: [{
            id: first_user.id,
            name: 'First User',
            created_at: first_user.created_at,
            score: 50,
            guess_ids: [],
            spot_ids: [first_users_spot.id]
          }, {
            id: second_user.id,
            name: 'Second User',
            created_at: second_user.created_at,
            score: 50,
            guess_ids: [],
            spot_ids: []
          }],
        }.to_json)

        # Test that resources are side loaded, but don't verify their format
        # here, leave that to the respective resources request specs since
        # we're using the same partials.
        expect(actual_response).to have_key('games')
        actual_response.delete('games')
        expect(actual_response).to have_key('spots')
        actual_response.delete('spots')
        expect(actual_response).to have_key('guesses')
        actual_response.delete('guesses')

        expect(actual_response).to eq(expected_response)
      end
    end

    describe 'GET /api/v1/users/1' do

      it 'should return details about the user' do
        get "/api/v1/users/#{first_user.id}.json", nil, authorization_headers_for_user(Seeds.user)
        expect(response).to be_success

        actual_response = JSON.parse(response.body)
        expected_response = JSON.parse({
          user: {
            id: first_user.id,
            name: 'First User',
            created_at: first_user.created_at,
            score: 50,
            guess_ids: [],
            spot_ids: [first_users_spot.id]
          }
        }.to_json)

        # Test that resources are side loaded, but don't verify their format
        # here, leave that to the respective resources request specs since
        # we're using the same partials.
        expect(actual_response).to have_key('games')
        actual_response.delete('games')
        expect(actual_response).to have_key('spots')
        actual_response.delete('spots')
        expect(actual_response).to have_key('guesses')
        actual_response.delete('guesses')

        expect(actual_response).to eq(expected_response)
      end
    end

    describe 'PUT /api/v1/users/1' do
      it 'should update the existing user' do
        update_params = {
          user: {
            name: 'My New Username'
          }
        }
        put "/api/v1/users/#{first_user.id}.json", update_params, authorization_headers_for_user(Seeds.user)
        expect(response).to be_success

        actual_response = JSON.parse(response.body)
        expected_response = JSON.parse({
          user: {
            id: first_user.id,
            name: 'My New Username',
            created_at: first_user.created_at,
            score: 50,
            guess_ids: [],
            spot_ids: [first_users_spot.id]
          }
        }.to_json)

        # Test that resources are side loaded, but don't verify their format
        # here, leave that to the respective resources request specs since
        # we're using the same partials.
        expect(actual_response).to have_key('games')
        actual_response.delete('games')
        expect(actual_response).to have_key('spots')
        actual_response.delete('spots')
        expect(actual_response).to have_key('guesses')
        actual_response.delete('guesses')

        expect(actual_response).to eq(expected_response)
      end
    end
  end
end

