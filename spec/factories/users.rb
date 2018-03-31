FactoryBot.define do
  factory :user do
    sequence(:name) { |i| "User ##{i}" }
  end
end
