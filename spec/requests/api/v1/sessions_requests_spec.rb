require 'rails_helper'

describe '/api/v1/sessions' do
  describe 'POST /api/v1/sessions' do
    let!(:user) { User.create_for_game!(email: email, password: password) }
    let(:api_key) { user.api_key }
    let(:email) { 'my-email@example.com' }
    let(:password) { 'my-password123' }

    before do
      post '/api/v1/sessions', { session: { email: 'my-email@example.com', password: 'my-password123' }}
    end

    it 'returns your api key' do
      expect(response).to be_success

      json = JSON.parse(response.body)
      expect(json).to have_key('session')
      expect(json['session']).to have_key('api_key')
      expect(json['session']['api_key']).to eq({
        'client_id' => api_key.client_id,
        'secret' => api_key.secret
      })
    end

    context 'with bad username' do
      let(:email) { 'bogus@example.com' }
      it 'returns an error' do
        expect(response).not_to be_success

        json = JSON.parse(response.body)
        expect(json).to have_key('error')
        expect(json['error']['message']).to match('authenticate')
      end
    end

    context 'with bad password' do
      let(:password) { 'BOGUS-PASSWORD' }
      it 'returns an error' do
        expect(response).not_to be_success

        json = JSON.parse(response.body)
        expect(json).to have_key('error')
        expect(json['error']['message']).to match('authenticate')
      end
    end
  end
end
