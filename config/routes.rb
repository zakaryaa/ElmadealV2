Rails.application.routes.draw do
  root to: 'pages#home'

  devise_for :users,
            path:'api/v1/user',
             controllers: {
               sessions: 'api/v1/user/sessions',
               registrations: 'api/v1/user/registrations'
             },
             defaults: {format: :json}

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
          resources :appointments, only: [:index]
        end

      end
end
end
