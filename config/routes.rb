Rails.application.routes.draw do

  #devise_for :users
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  resource :user

  #get 'sites/index'
  #root to: "sites#index"
  get 'statics/top'
  get 'statics/first'
  get 'statics/functions'
  root to: 'statics#top'

  resources :teams do
    member do
      post 'delegate'
    end
    resources :assigns, only: %w(create destroy)
    resources :sites do
      collection do
        post :confirm
      end
      member do
        post :confirm_edit
      end
      resources :comments, shallow: true
      resources :image_posts, shallow: true
      get 'search'
    end
  end

  resources :labels

#  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  mount LetterOpenerWeb::Engine, at: "/letter_opener"
end
