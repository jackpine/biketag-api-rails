json.spot do
  json.partial! 'spot', spot: @spot
end

json.guesses do
  json.array! @spot.guesses, partial: 'guess', as: :guess
end
