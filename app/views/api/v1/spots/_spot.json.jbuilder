json.extract! spot, :id, :created_at, :image_url, :user_id
json.url api_v1_spot_url(spot, format: :json)
json.guess_ids spot.guesses.map &:id
json.user_name spot.user.name
json.game_id spot.game.id

if can? :read_location, spot
  json.location spot.location
else
  json.location nil
end
