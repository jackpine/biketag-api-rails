json.extract! spot, :id, :created_at, :image_url, :location
json.url api_v1_spot_url(1, spot, format: :json)
json.guess_ids spot.guesses.map &:id
json.user_id 1
json.user_name "michael"
json.game_id 1
