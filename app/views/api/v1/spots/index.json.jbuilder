json.spots do
  json.array! @spots, partial: 'spot', as: :spot
end

json.guesses do
  json.array! @guesses, partial: 'api/v1/guesses/guess', as: :guess
end

json.games do
  json.array! @games, partial: 'api/v1/games/game', as: :game
end

json.users do
  json.array! @users, partial: 'api/v1/users/user', as: :user
end

