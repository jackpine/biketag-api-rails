require 'rails_helper'

describe 'user requests' do
  context 'with a set up game' do
    before do
      require Rails.root + 'db/seeds.rb'
      Seeds.seed!
    end
    let(:first_user) { Seeds.user }

    describe 'GET /api/v1/users' do
      let!(:second_user) { User.create_for_game!(name: 'Second User') }
      it 'should return an array of users' do
        get "/api/v1/users.json", nil, Seeds.authorization_headers
        expect(response).to be_success

        actual_response = JSON.parse(response.body)
        expected_response = JSON.parse({
          users: [{
            id: first_user.id,
            name: 'First User',
            created_at: first_user.created_at,
            score: 50
          }, {
            id: second_user.id,
            name: 'Second User',
            created_at: second_user.created_at,
            score: 50
          }]
        }.to_json)

        expect(actual_response).to eq(expected_response)
      end
    end

    describe 'GET /api/v1/users/1' do

      it 'should return details about the user' do
        get "/api/v1/users/#{first_user.id}.json", nil, Seeds.authorization_headers
        expect(response).to be_success

        actual_response = JSON.parse(response.body)
        expected_response = JSON.parse({
          user: {
            id: first_user.id,
            name: 'First User',
            created_at: first_user.created_at,
            score: 50
          }
        }.to_json)

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
        put "/api/v1/users/#{first_user.id}.json", update_params, Seeds.authorization_headers
        expect(response).to be_success

        actual_response = JSON.parse(response.body)
        expected_response = JSON.parse({
          user: {
            id: first_user.id,
            name: 'My New Username',
            created_at: first_user.created_at,
            score: 50
          }
        }.to_json)

        expect(actual_response).to eq(expected_response)
      end
    end
  end
end

