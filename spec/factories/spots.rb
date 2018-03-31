FactoryBot.define do
  factory :spot do
    image { fake_file }
    user
    game
    location { { 'type' => 'Point', 'coordinates' => [118.0, 34.0] } }
  end
end
