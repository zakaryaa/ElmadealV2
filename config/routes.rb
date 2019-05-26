Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'

  #get 'test' =>'pages#test'
end
