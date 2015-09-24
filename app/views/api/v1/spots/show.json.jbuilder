json.spot do
  json.partial! 'spot', spot: @spot
end

json.guesses do
  json.array! @spot.guesses, partial: 'api/v1/guesses/guess', as: :guess
end
