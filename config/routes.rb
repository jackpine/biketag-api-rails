Rails.application.routes.draw do

  namespace 'api' do
    namespace 'v1' do
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
