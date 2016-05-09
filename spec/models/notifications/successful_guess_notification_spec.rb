require 'rails_helper'

describe Notifications::SuccessfulGuessNotification do

  let(:guess) { double(user_name: 'Mustafa') }
  let(:notification) { Notifications::SuccessfulGuessNotification.new(guess) }

  describe '#push_notification' do
    subject { notification.push_notification }

    it { expect(subject).to be_a(Houston::Notification) }

    it "should specify the guesser's name" do
      expect(subject.alert).to include('Mustafa')
    end

  end
end
