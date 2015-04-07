json.games do
  json.array! @games, partial: 'game', as: :game
end
