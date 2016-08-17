# Omniauth login demo

## Features
- Log in with email.
- Log in with Twitter etc.
- Four types of dashboard interfaces:
  + users
  + clients
  + account executives
  + admins

## Gem dependencies
- Omniauth
- Devise

## How to run the test suite
```
$ guard
```

---

## Set up gems

### simple form

```bash
$ rails generate simple_form:install --bootstrap

# Inside your views, use the 'simple_form_for' with one of the Bootstrap form
# classes, '.form-horizontal' or '.form-inline', as the following:
#
#   = simple_form_for(@user, html: { class: 'form-horizontal' }) do |form|
```

### devise
I will create four devise models that are scoped separately.

- [wiki](http://devise.plataformatec.com.br/#the-devise-wiki)
- [rails-devise-scoped-views](http://mnishiguchi.com/2016/08/03/rails-devise-scoped-views/)

#### Install devise
```
$ rails generate devise:install
```

#### Enable scoped views
```rb
# /config/initializers/devise.rb
config.scoped_views = true
```

#### Create devise models (e.g., user, admin)

```
$ rails g devise user
$ rails g devise client
$ rails g devise account_executive
$ rails g devise admin
```

#### Configure devise modules to be included in each devise model
```rb
class Admin < ApplicationRecord
  devise :database_authenticatable, :trackable, :validatable
  ...
end
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :omniauthable
  ...
end
```

#### Configure migration files for each model
Configure migration files for each model according to devise modules to be used.

```rb
class DeviseCreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
```

Then

```
$ rails db:migrate
```

#### Create devise controllers
```
$ rails g devise:controllers users
$ rails g devise:controllers clients
$ rails g devise:controllers account_executives
$ rails g devise:controllers admins
```

#### Configure namespaced devise routes
```rb
Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions:           "admins/sessions"
  }
  devise_for :users, controllers: {
    sessions:           "users/sessions",
    passwords:          "users/passwords",
    registrations:      "users/registrations",
    confirmations:      "users/confirmations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  ...
end
```

#### Set up mailer
Make sure that you configure mailer for all three environments in `config/environments/*`.

Then, set up sendgrid on heroku.

```
$ heroku addons:create sendgrid:starter
```

Then, set up the route for `letter_opener_web`

```rb
Rails.application.routes.draw do
  root to: 'static_pages#home'
  ...
  # For viewing delivered emails in development environment.
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
```

#### Error: Devise - ActionView::Template::Error (Missing host to link to! Please provide the :host parameter, set default_url_options[:host], or set :only_path to true):
- Make sure that you configure mailer for all three environments in `config/environments/*`.

#### Missing host to link to! Please provide the :host parameter, set default_url_options[:host], or set :only_path to true
- Make sure that you configure mailer for all three environments in `config/environments/*`.

---


## Some techniques

#### Load seed file in test

```rb
load "#{Rails.root}/db/seeds.rb"
```

or

```rb
Rails.application.load_seed
```
