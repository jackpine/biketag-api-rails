json.url api_v1_guess_url(1, guess.spot, guess, format: :json)
json.extract! guess, :id, :created_at, :correct, :location, :distance, :spot_id
json.game_id 1
json.user_name guess.user.name
