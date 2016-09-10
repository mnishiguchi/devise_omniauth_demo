Rails.application.routes.draw do

  root "static_pages#home"


  # ===
  # General users
  # ===

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations:      "users/registrations",
    confirmations:      "users/confirmations",
    sessions:           "users/sessions",
    passwords:          "users/passwords"
  }

  # Ask for email address after successful OAuth.
  match "/users/:id/finish_signup" => "users#finish_signup",
    via: [:get, :patch], as: :user_finish_signup

  resources :users, only: :index

  resources :social_profiles, only: [:index, :destroy]


  # ===
  # Client users
  # ===

  devise_for :clients, controllers: {
    confirmations:      "clients/confirmations",
    sessions:           "clients/sessions",
    passwords:          "clients/passwords"
  }
  resources :clients, only: [:index, :show]


  # ===
  # Admin users (a few types)
  # ===

  devise_for :admins, controllers: {
    sessions:           "admins/sessions",
    passwords:          "admins/passwords"
  }
  resources :admins, only: :index
  resources :administrators, only: :show
  resources :account_executives, only: :show
  resources :super_users, only: :show


  # ===
  # Properties
  # ===

  resources :properties do
    resources :likes, only: :create
    get :search, on: :collection
  end


  # ===
  # Likeable
  # ===

  resources :likes, only: [:index, :destroy]


  # ===
  # Letter operner
  # ===

  # For viewing delivered emails in development environment.
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
