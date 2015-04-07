json.spots do
  json.array! @spots, partial: 'spot', as: :spot
end
