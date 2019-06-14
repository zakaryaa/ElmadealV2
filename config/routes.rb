Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :salons  do
        resources :appointments
        resources :services do
          resources :promotions
        end
        resources :opening_hours
        resources :photos
        resources :roles
        resources :ratings
      end
      resources :appointments, only: [:index]
  end
end
end
