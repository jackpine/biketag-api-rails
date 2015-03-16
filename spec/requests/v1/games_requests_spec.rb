require 'rails_helper'

describe 'spots requests' do
  describe 'GET /v1/games/1/current_spot' do
    it 'returns the current spot' do
      get '/v1/games/1/current_spot'
      expect(response).to be_success

      actual_response = JSON.parse(response.body)

      expected_response = {
        spot:  {
          id: 123,
          user_id: 456,
          image_url: "https://biketag.s3.aws.com/foo/bar/1235.jpg",
          captured_at: "2015-03-12 16:12:01 PDT"
        }
      }

      expect(actual_response).to eq(expected_response)
    end
  end
end
