require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    describe 'password' do
      it 'does not require a password unless there is an email' do
        user = User.new
        user.valid?
        expect(user.errors).not_to have_key(:password)

        user.email = "foo@example.com"
        user.valid?
        expect(user.errors).to have_key(:password)

        user.password = "my-very-super-secret-password"
        user.valid?
        expect(user.errors).not_to have_key(:password)
      end
    end
    describe 'name' do
      let(:user) { User.new(name: user_name) }
      context 'with no name' do
        let(:user_name) { nil }
        it { expect(user).to be_valid }
      end
      context 'with less than 4 characters' do
        let(:user_name) { 'abc' }
        it { expect(user).not_to be_valid }
      end
      context 'with more than 20 characters' do
        let(:user_name) { 'abcdefghijklmnopqrstu' }
        it { expect(user).not_to be_valid }
      end
      context 'between 4 and 20 characters' do
        let(:user_name) { 'abcdefghijklmnopqrst' }
        it { expect(user).to be_valid }
      end
    end
  end

  describe '#name' do
    let(:user) { User.new(name: user_name).tap { |u| u.id = 2 } }
    context 'without a name set' do
      let(:user_name) { nil }
      it 'defaults to user+id' do
        expect(user.name).to eq('User #2')
      end
    end
    context 'with a name set' do
      let(:user_name) { 'Juan' }
      it 'uses the specified name' do
        expect(user.name).to eq('Juan')
      end
    end
  end

  describe '#compute_score' do
    context 'with some score transactions' do
      let(:user) { FactoryGirl.create(:user) }
      let!(:first_score) { FactoryGirl.create(:score_transaction, user: user, amount: 11) }
      let!(:second_score) { FactoryGirl.create(:score_transaction, user: user, amount: 4) }

      it 'should compute the score' do
        user.update_attribute(:score, 0)
        user.compute_score
        expect(user.score).to eq(15)
        first_score.destroy
        expect(user.score).to eq(4)
      end
    end
  end

  describe '#create_for_game' do
    it 'sets up a user to play' do
      user = User.create_for_game!
      expect(user.name.length).to be >= 6
      expect(user.api_key).to be_a(ApiKey)
      expect(user.score_transactions).to_not be_empty
      expect(user.score).to eq(50)
    end
  end
end
