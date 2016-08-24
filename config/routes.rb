Rails.application.routes.draw do
  root to: 'static_pages#home'

  devise_for :users, controllers: {
    sessions:           "users/sessions",
    passwords:          "users/passwords",
    registrations:      "users/registrations",
    confirmations:      "users/confirmations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  devise_for :clients, controllers: {
    sessions:           "clients/sessions",
    passwords:          "clients/passwords",
    registrations:      "clients/registrations",
    confirmations:      "clients/confirmations",
  }
  devise_for :account_executives, controllers: {
    sessions:           "account_executives/sessions"
  }
  devise_for :admins, controllers: {
    sessions:           "admins/sessions"
  }

  # Ask for email address after successful OAuth.
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], as: :finish_signup

  get 'static_pages/home' => 'static_pages#home'

  resources :social_profiles, only: :destroy

  # For viewing delivered emails in development environment.
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
