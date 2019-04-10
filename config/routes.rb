Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :partenaires
  devise_for :users, controllers: { sessions: 'users/sessions' , registrations: 'users/registrations' }
  devise_for :admins, path: 'admins'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # Frontoffice routes
  root to: 'pages#home'
  resources :salons
  get "appointments/:id", to: "appointments#show", as: :appointment
  post "appointments/:service_id", to: "appointments#create", as: :appointment_create


  # Backoffice routes
  get 'backoffice/dashboard/:salon_id', to: 'backoffice#index', as: :dashboard
  post "calendar", to: "backoffice#addAppointement"

  # Backoffice API routes
  constraints format: :json do
    namespace :api do
      namespace :v1 do
        resources :salons, only: [:index,:show,:create,:update,:destroy] do
          resources :services, only: [:index,:show,:create,:update,:destroy]
          resources :appointments, only: [:index,:show,:create,:update,:destroy]
          resources :users, only: [:show,:update,:destroy]
          resources :employees, only: [:index,:create] do
            resources :skills, only: :index
          end
          resources :customers, only: [:index,:create]
        end
      end
    end
  end

  get '/.well-known/acme-challenge/:id' => 'pages#letsencrypt'
  devise_scope :user do
    get "connexion-institut", to: "users/sessions#new"
 end
end