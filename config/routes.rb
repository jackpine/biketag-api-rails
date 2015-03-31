Rails.application.routes.draw do

  namespace 'api' do
    namespace 'v1' do
      resources :games, only: [:show, :index], defaults: { format: :json } do
        resources :spots, only: [:create, :show, :index], defaults: { format: :json } do
          resources :guesses, only: [:create, :show, :index], defaults: { format: :json }
        end
        member do
          get :current_spot
        end
      end
    end
  end

end
