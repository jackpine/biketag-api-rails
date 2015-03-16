Rails.application.routes.draw do

  get 'api/v1/games/1/current_spot.:format' => 'api/v1/games#current_spot'

end
