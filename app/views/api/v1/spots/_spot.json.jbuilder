json.spot do
  json.extract! spot, :id, :created_at, :image_url
  json.url api_v1_game_spot_url(1, spot, format: :json)
  json.user_id 1
  json.user_name "michael"
end
