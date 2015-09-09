FactoryGirl.define do
  factory :spot do
    image { fake_file }
    user
    game
    location { RGeo::GeoJSON.decode({ 'type' => 'Point', 'coordinates' => [118.0, 34.0] }) }
  end
end
