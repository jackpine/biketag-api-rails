json.extract! @spot, :id, :created_at, :location
json.url api_v1_game_spot_url(1, @spot, format: :json)
json.image_url @spot.image_url
