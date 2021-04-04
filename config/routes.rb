Rails.application.routes.draw do

  #devise_for :users
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  #get 'sites/index'
  root to: "sites#index"
  resources :sites

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
