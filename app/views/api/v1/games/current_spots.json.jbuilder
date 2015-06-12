json.spots do
  json.array! @spots, partial: 'api/v1/spots/spot', as: :spot
end
