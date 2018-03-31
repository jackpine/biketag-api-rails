FactoryBot.define do
  factory :device do
    sequence(:notification_token) { |i| "some-fake-notification-token-#{i}" }
  end
end
