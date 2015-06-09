Rails.application.routes.draw do
  namespace 'api' do
    match '*any_options_path', to: 'base#handle_options_request', via: :options
    namespace 'v1' do
      resources :api_keys, only: [:create], defaults: { format: :json }
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

  # We don't want to use any of the devise routes, but tests are failing (and
  # maybe the app fails, who knows?) without declaring a devise scope
  devise_for :users, skip: [ :sessions, :passwords, :registrations,
                             :confirmations]

end
