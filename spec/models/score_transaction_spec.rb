require 'rails_helper'

RSpec.describe ScoreTransaction, type: :model do
  describe '#after_create' do
    let(:user) { mock_model User, score: 50 }
    it "updates the user's score" do
      expect(user).to receive(:compute_score)
      ScoreTransaction.create!(user: user, amount: 22, description: 'my description')
    end
  end
end
