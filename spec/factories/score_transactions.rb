FactoryBot.define do
  factory :score_transaction do
    sequence(:description) { |i| "Score Transaction ##{i}" }
  end
end
