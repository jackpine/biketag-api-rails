Rails.application.routes.draw do

  # We don't have any views to auth users yet
  # - only the sessions/api key exchange
  # devise_for :users
  namespace 'api' do
    namespace 'v1' do
      post :sessions, to: 'sessions#create'

      resources :games, only: [:show, :index], defaults: { format: :json } do
        member do
          get :current_spot
        end
      end
      resources :spots, only: [:create, :show, :index], defaults: { format: :json }
      resources :guesses, only: [:create, :show, :index], defaults: { format: :json }
    end
  end

  root to: "pages#home"

end
