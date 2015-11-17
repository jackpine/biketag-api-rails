require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before do
    stub_authentication!
  end

  describe "#show" do
    let(:user) { mock_model(User, spots: [], guesses: [], games: []) }
    it 'shows user details' do
      expect(User).to receive(:find).with('2').and_return(user)
      get :show, id: 2, format: :json
      expect(response).to be_success
      expect(assigns(:user)).to eq(user)
    end
  end
end
