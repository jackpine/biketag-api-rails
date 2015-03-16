json.extract! @spot, :id, :created_at, :location, :user_id, :user_name
json.url api_v1_spot_url(@spot, format: :json)
json.image_url @spot.medium_url
