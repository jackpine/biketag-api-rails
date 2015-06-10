json.extract! game, :id, :name, :spot_ids
json.current_spot do
  json.partial! 'api/v1/spots/spot', spot: game.current_spot
end
