Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :salons
      resources :appointments
    end
  end
end
