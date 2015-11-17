json.url api_v1_guess_url(guess, format: :json)
json.extract! guess, :id, :created_at, :correct, :location, :distance, :spot_id, :game_id, :image_url, :user_id
json.user_name guess.user.name
