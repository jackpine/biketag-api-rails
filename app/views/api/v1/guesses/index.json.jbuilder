json.guesses do
  json.array! @guesses, partial: 'guess', as: :guess
end

json.spots do
  json.array! @spots, partial: 'api/v1/spots/spot', as: :spot
end

json.games do
  json.array! @games, partial: 'api/v1/games/game', as: :game
end

