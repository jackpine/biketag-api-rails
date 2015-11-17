json.extract! user, :id, :score, :name, :created_at

json.guess_ids user.guesses.map &:id
json.spot_ids user.spots.map &:id
