Rails.application.routes.draw do
  resources :posts
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  # get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  post "toggle_like", to: "likes#toggle_like", as: :toggle_like

  resources :comments, only: [:create, :destroy]

  resources :users, only: [:show, :index]

  post "follow", to: "follows#follow", as: :follow
  delete "follow", to: "follows#unfollow", as: :unfollow
  delete "cancel_request", to: "follows#cancel_request", as: :cancel_request

  post "accept_follow", to: "follows#accept_follow", as: :accept_follow
  delete "decline_follow", to: "follows#decline_follow", as: :decline_follow

  resources :messages, only: [:index, :create]

  resources :invites, only: [:index, :show]
  post "send_invite", to: "invites#send_invite", as: :send_invite
  post "accept_invite/:id", to: "invites#accept_invite", as: :accept_invite
  delete "decline_invite/:id", to: "invites#decline_invite", as: :decline_invite
  
end
