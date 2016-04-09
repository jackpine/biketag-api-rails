require 'rails_helper'

describe 'device requests' do
  context 'with a set up game' do
    before do
      require Rails.root + 'db/seeds.rb'
      Seeds.seed!
    end

    let(:user) { Seeds.user }

    describe 'POST /api/v1/devices' do
      it "registers a new device with the current user's account" do
        expect {
          post '/api/v1/devices', { device: { notification_token: "some-fake-token" }}, authorization_headers_for_user(user)
        }.to change { user.device_notification_tokens.count }.by(1)

        expect(response).to be_success

        last_device = Device.last
        expected_response = JSON.parse({
          device: {
            id: last_device.id,
            user_id: user.id,
            created_at: last_device.created_at
          }
        }.to_json)

        expect(parsed_response).to eq(expected_response)
      end

      it "fails with malformed token" do
        expect {
          post '/api/v1/devices', { device: { notification_token: "" }}, authorization_headers_for_user(user)
        }.not_to change { user.device_notification_tokens.count }
        expect(response).not_to be_success

        expect(response).to have_error("token can't be blank")
      end
    end

  end
end
