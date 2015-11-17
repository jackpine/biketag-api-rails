json.user do
  json.partial! 'user', user: @user
end

json.spots do
  json.array! @spots, partial: 'api/v1/spots/spot', as: :spot
end

json.guesses do
  json.array! @guesses, partial: 'api/v1/guesses/guess', as: :guess
end

json.games do
  json.array! @games, partial: 'api/v1/games/game', as: :game
end

