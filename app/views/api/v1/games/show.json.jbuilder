json.game do
  json.partial! 'game', game: @game
end

json.spots do
  json.array! @spots, partial: 'api/v1/spots/spot', as: :spot
end

json.guesses do
  json.array! @guesses, partial: 'api/v1/guesses/guess', as: :guess
end
