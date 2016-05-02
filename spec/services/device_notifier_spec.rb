require 'rails_helper'

describe DeviceNotifier do

  let(:device_notifier) { DeviceNotifier.new }

  describe '.notification_client_mode=' do
    subject { DeviceNotifier.new.send(:client) }
    after do
      # Make sure we're returning to test mode ;)
      DeviceNotifier.notification_environment = :fake
    end

    it 'has a production mode' do
      DeviceNotifier.notification_environment = :production
      expect(subject).to be_a(Houston::Client)
    end

    it 'has a development mode' do
      DeviceNotifier.notification_environment = :development
      expect(subject).to be_a(Houston::Client)
    end

    it 'has a fake mode' do
      DeviceNotifier.notification_environment = :fake
      expect(subject).to be_a(DeviceNotifier::FakeAPNSClient)
    end

    it 'blows up with invalid mode' do
      expect {
        DeviceNotifier.notification_environment = :foo
      }.to raise_error(ArgumentError)
    end
  end

  describe '#deliver_now' do
    subject { device_notifier.deliver_now(fake_notification, to: recipient) }
    let(:client) { device_notifier.send(:client) }
    let(:push_notification) { Houston::Notification.new }
    let(:fake_notification) { double('fake notification', push_notification: push_notification) }

    context 'one recipient' do
      let(:recipient) { 'foo' }
      it 'should send a notification' do
        expect { subject }.to change {
          client.delivered_notifications.length
        }.by 1
      end
    end

    context 'multiple recipients' do
      let(:recipient) { ['foo', 'bar'] }
      it 'should send one to each' do
        expect { subject }.to change {
          client.delivered_notifications.length
        }.by 2
      end
    end

    context 'nil recipients' do
      let(:recipient) { nil }
      it 'should send one to each' do
        expect { subject }.not_to change {
          client.delivered_notifications.length
        }
      end
    end
  end

end
