Rails.application.routes.draw do

  #devise_for :users
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  resource :user

  get 'statics/top'

  #get 'sites/index'
  #root to: "sites#index"
  root to: 'statics#top'

  resources :teams do
    member do
      post 'delegate'
    end
    resources :assigns, only: %w(create destroy)
    resources :sites do
      resources :comments, shallow: true
      resources :image_posts, shallow: true
      get 'search'
    end
  end

  resources :labels
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
