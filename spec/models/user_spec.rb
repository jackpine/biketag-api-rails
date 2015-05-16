require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    describe 'password' do
      it 'does not require a password unless there is an email' do
        user = User.new
        expect(user).to be_valid
        user.email = "foo@example.com"
        expect(user).to_not be_valid
        user.password = "my-very-super-secret-password"
        expect(user).to be_valid
      end
    end
  end
end
