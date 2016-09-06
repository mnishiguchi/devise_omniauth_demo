Rails.application.routes.draw do
  resources :properties
  root to: "static_pages#home"

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations:      "users/registrations",
    confirmations:      "users/confirmations",
    sessions:           "users/sessions",
    passwords:          "users/passwords"
  }
  devise_for :clients, controllers: {
    confirmations:      "clients/confirmations",
    sessions:           "clients/sessions",
    passwords:          "clients/passwords"
  }
  devise_for :admins, controllers: {
    sessions:           "admins/sessions",
    passwords:          "admins/passwords"
  }

  # Ask for email address after successful OAuth.
  match "/users/:id/finish_signup" => "users#finish_signup", via: [:get, :patch], as: :user_finish_signup

  # Sometimes after invalid form submission, Devise hits `/users` for some reason.
  # Therefore we need to define this to avoid an exception raised.
  get "users" => "static_pages#home"

  resources :social_profiles, only: :destroy

  resources :properties

  # For viewing delivered emails in development environment.
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
