require 'rails_helper'

describe Api::Error do

  describe Api::Error::Unauthorized do
    it 'has a default error message' do
      expect(Api::Error::Unauthorized.new.message).not_to be_empty
    end
    it 'allows you to overwrite the error message' do
      expect(Api::Error::Unauthorized.new('custom message').message).to eq 'custom message'
    end
    it 'has a json representation' do
      expected_representation = {
        error: {
          code: 179,
          message: "custom message"
        }
      }
      expect(Api::Error::Unauthorized.new('custom message').as_json).to eq expected_representation
    end
  end
end
