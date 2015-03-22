Rails.application.routes.draw do

  namespace 'api' do
    namespace 'v1' do
      resources :games, only: [] do
        resources :spots, only: [:show] do
          resources :guesses, only: [:create]
        end
        member do
          get :current_spot
        end
      end
    end
  end

end
