# Setting up OmniAuth for Devise
- [Devise+OmniAuthでQiita風の複数プロバイダ認証](http://qiita.com/mnishiguchi/items/e15bbef61287f84b546e) by Masatoshi Nishiguchi

## Description
- Authentication with multiple social providers for a Devise user.
- Extensible for more providers in the future.

![Screenshot 2015-08-13 20.04.34.png](https://qiita-image-store.s3.amazonaws.com/0/82804/a1e2a73d-db56-b375-ed91-7dc4ec201e77.png)
===
![Screenshot 2015-08-15 10.11.13.png](https://qiita-image-store.s3.amazonaws.com/0/82804/166c1d09-33ab-8066-cc0c-1ba4c200fa46.png)


### Registration scenarios (2 patterns）

1. with an email and a password
2. with a social account (password is not required)


### OAuth authentication scenarios（3 patterns)

**New user**:
Create a new account for that user.
**Logged-in user**:
Store that social info so that the user can log in with that social provider.
**Not logged in but previously registered with a social provider**:
Log the user.


### Email confirmation
- We need to ensure that email addresses the users provide are real and valid.
- No matter how the user is registered, the user must go through email confirmation procedure.
  + The user receives an email with a confirmation link which logs him/her in on click.
- The same procedure is required for the user when updating email address.


### Linking user to his/her social profiles

- Non-logged-in user who is not previously registered with a social provider
  + An attempt to log in with a social provider results in a new user account.
- Logged-in user
  + can connect to a social provider by clicking on a social link button. Then next time the user can log in with that social provider.


### Password

- Password is not required if the user logs in with a social provider.


---

## Implementation

### Install gems

Add `devise` and `omniauth`-related gems to `Gemfile`.

```rb
...
# ruby 2.3.1
gem 'rails', '>= 5.0.0.rc2', '< 5.1'

# `devise` and `omniauth`-related gems
gem 'devise', '4.2'
gem 'omniauth', '~> 1.3', '>= 1.3.1'
gem 'omniauth-facebook', '~> 3.0'
gem 'omniauth-twitter', '~> 1.2', '>= 1.2.1'
...
```


### Set up Devise

- Follow instructions in [docs](http://devise.plataformatec.com.br/#the-devise-wiki).
- Here I enabled `confirmable` and `reconfirmable`.

`/app/models/user.rb`

```rb
class User < ApplicationRecord
  ...
  # Devise modules.
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :omniauthable
  ...
```

`/config/initializers/devise.rb`

```rb
Devise.setup do |config|
  ...
  config.reconfirmable = true
  ...
end
```

`/db/migrate/20160701172600_devise_create_users.rb`

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

### Obtain key and secret for each provider

- [https://apps.twitter.com/](https://apps.twitter.com/)
  + Use `http://127.0.0.1:3000/` for callback url.
- [https://developers.facebook.com/](https://developers.facebook.com/)


### Configure OAuth for each provider

```rb:/config/initializers/devise.rb
Devise.setup do |config|
  ...
  config.omniauth :facebook, "KEY", "SECRET"
  config.omniauth :twitter, "KEY", "SECRET"
  ...
end
```

NOTE: There are many different ways to manage API keys. For instance, [this article](http://qiita.com/awakia/items/03dd68dea5f15dc46c15#%E5%90%84provider%E3%81%AEoauth%E8%A8%AD%E5%AE%9A) talks about managing API keys in a separate file named `config/omniauth.yml`.


### Models

#### User model
- The username field is optional.

`/app/models/user.rb`

```rb
class User < ApplicationRecord
  has_many :social_profiles, dependent: :destroy

  # Configure devise modules.
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :omniauthable

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Validate email with a custom email validator.
  validates :email, presence: true, email: true

  def social_profile(provider)
    social_profiles.select{ |sp| sp.provider == provider.to_s }.first
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def reset_confirmation!
    self.update_column(:confirmed_at, nil)
  end

  # Makes current_user available via User.
  # Userd in ApplicationController.
  def self.current_user=(user)
    Thread.current[:current_user] = user
  end

  # References current_user via User.
  def self.current_user
    Thread.current[:current_user]
  end
end
```

`/app/validators/email_validator.rb`

```rb
require 'mail'

# https://github.com/plataformatec/devise/wiki/How-to:-Use-a-custom-email-validator-with-Devise
class EmailValidator < ActiveModel::EachValidator

  def validate_each(record,attribute,value)
    begin
      m = Mail::Address.new(value)
      # We must check that value contains a domain, the domain has at least
      # one '.' and that value is an email address
      r = m.domain!=nil && m.domain.match('\.') && m.address == value

    rescue Exception => e
      r = false
    end
    record.errors[attribute] << (options[:message] || "is invalid") unless r

    # Reject temporary email address
    record.errors[attribute] << 'must be given. Please give us a real one!!!' unless value !~ User::TEMP_EMAIL_REGEX
  end
end
```


#### SocialProfile model

```bash
rails g model SocialProfile user:references provider uid name nickname email url image_url description others:text credentials:text raw_info:text
```

Add an index to the generated migration file.

`/db/migrate/20160709210000_create_social_profiles.rb`

```rb
class CreateSocialProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :social_profiles do |t|
      t.references :user, foreign_key: true
      t.string :provider
      t.string :uid
      t.string :name
      t.string :nickname
      t.string :email
      t.string :url
      t.string :image_url
      t.string :description
      t.text :others
      t.text :credentials
      t.text :raw_info

      t.timestamps
    end
    add_index :social_profiles, [:provider, :uid], unique: true
  end
end
```

Then `rake db:migrate`

`/app/models/social_profile.rb`

```rb
class SocialProfile < ApplicationRecord
  belongs_to :user
  store      :others

  validates_uniqueness_of :uid, scope: :provider

  def self.find_for_oauth(auth)
    profile = find_or_create_by(uid: auth.uid, provider: auth.provider)
    profile.save_oauth_data!(auth)
    profile
  end

  def save_oauth_data!(auth)
    return unless valid_oauth?(auth)

    provider = auth["provider"]
    policy   = policy(provider, auth)

    self.update_attributes( uid:         policy.uid,
                            name:        policy.name,
                            nickname:    policy.nickname,
                            email:       policy.email,
                            url:         policy.url,
                            image_url:   policy.image_url,
                            description: policy.description,
                            credentials: policy.credentials,
                            raw_info:    policy.raw_info )
  end

  private

    def policy(provider, auth)
      class_name = "#{provider}".classify
      "OAuthPolicy::#{class_name}".constantize.new(auth)
    end

    def valid_oauth?(auth)
      (self.provider.to_s == auth['provider'].to_s) && (self.uid == auth['uid'])
    end
end
```


### OAuthPolicy

- Each provider has a similar-but-slightly-different schema. Therefore this class processes the data into a standardized format.
- This way, processing data in SocialProfile model becomes simple and SocialProfile model can focus on persisting data.

`/app/helpers/o_auth_policy.rb`

```rb
module OAuthPolicy
  class Base
    attr_reader :provider, :uid, :name, :nickname, :email, :url, :image_url,
                :description, :other, :credentials, :raw_info
  end

  class Twitter < OAuthPolicy::Base
    def initialize(auth)
      @provider    = auth["provider"]
      @uid         = auth["uid"]
      @name        = auth["info"]["name"]
      @nickname    = auth["info"]["nickname"]
      @email       = ""
      @url         = auth["info"]["urls"]["Twitter"]
      @image_url   = auth["info"]["image"]
      @description = auth["info"]["description"].try(:truncate, 255)
      @credentials = auth["credentials"].to_json
      @raw_info    = auth["extra"]["raw_info"].to_json
      freeze
    end
  end
end
```


### Routing

`/config/routes.rb`

```rb
Rails.application.routes.draw do
  ...
  devise_for :users, controllers: {
    sessions:           "users/sessions",
    passwords:          "users/passwords",
    registrations:      "users/registrations",
    confirmations:      "users/confirmations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  # Ask for email address after successful OAuth.
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], as: :finish_signup

  ...
end
```


### Controllers

### ApplicationController

```rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_user

  protected

    def configure_permitted_parameters
      added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end

    # Make current_user accessible via User.
    def set_current_user
      User.current_user = current_user
    end
end
```


#### Users::OmniauthCallbacksController

`/app/controllers/users/omniauth_callbacks_controller.rb`

```rb
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # Invoked after omniauth authentication is done.
  # This method can handle authentication for all the providers.
  # Alias this method as a provider name such as `twitter`, `facebook`, etc.
  def callback_for_all_providers

    # Obtain the authentication data.
    @omniauth = request.env["omniauth.auth"]

    # Ensure that the authentication data exists.
    unless @omniauth.present?
      flash[:danger] = "Authentication data was not provided"
      redirect_to root_url and return
    end

    # Obtain the provider name from the callee.
    provider = __callee__.to_s

    # Search for the user based on the authentication data.
    # Obtain a SocialProfile object that corresponds to the authentication data.
    profile = SocialProfile.find_for_oauth(@omniauth)

    # Obtain logged-in user or user with a registered profile.
    @user = User.current_user || profile.user

    # If user was not found, search by email or create a new user.
    @user ||= find_by_verified_email_or_create_new_user(@omniauth)

    associate_user_with_profile(@user, profile)

    if @user.persisted? && @user.email_verified?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
    else
      @user.reset_confirmation!
      flash[:warning] = "Please enter your email address before proceeding."
      redirect_to finish_signup_path(@user)
    end
  end

  # Alias the callback_for_all_providers method for providers.
  alias_method :facebook, :callback_for_all_providers
  alias_method :twitter,  :callback_for_all_providers

  private

    def find_by_verified_email_or_create_new_user(auth)

      # If the authentication data includes verified email, search for user.
      email = verified_email_from_oauth(auth)
      user = User.where(email: email).first if email

      unless user
        # If user has no verified email, give the user a temp email address.
        # Later, we can detect unregistered email based on TEMP_EMAIL_PREFIX.
        # Password is not required for users with social_profiles therefore
        # it is OK to generate a random password for them.
        temp_email = "#{User::TEMP_EMAIL_PREFIX}-#{Devise.friendly_token[0,20]}.com"
        user = User.new(username: auth.extra.raw_info.name,
                        email:    email ? email : temp_email,
                        password: Devise.friendly_token[0,20] )

        # This is to postpone the delivery of confirmation email.
        user.skip_confirmation!

        # Save the temp email to database, skipping validation.
        user.save(validate: false)
        user
      end
    end

    def verified_email_from_oauth(auth)
      auth.info.email if auth.info.email && (auth.info.verified || auth.info.verified_email)
    end

    def associate_user_with_profile(user, profile)
      unless profile.user == user
        profile.update!(user_id: user.id)
      end
    end
end
```


#### UsersController

`/app/controllers/users_controller.rb`

```rb
class UsersController < ApplicationController
  before_action :authenticate_user!, except: :finish_signup

  # GET   /users/:id/finish_signup - Add email form
  # PATCH /users/:id/finish_signup - Update user data based on the form
  def finish_signup
    @user = User.find(params[:id])
    if request.patch? && @user.update(user_params)
      @user.send_confirmation_instructions unless @user.confirmed?
      flash[:info] = 'We sent you a confirmation email. Please find a confirmation link.'
      redirect_to root_url
    end
  end

  private

    def user_params
      accessible = [ :email ]

      # Ignore password if password is blank.
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end
```

`app/views/users/finish_signup.html.slim`

```slim
.row
  .col-sm-offset-3.col-sm-6
    .well
      .h4 Please enter your email address.
      = simple_form_for(@user, url: finish_signup_path(@user)) do |f|
        = f.input :email, autofocus: true, class: 'form-control'
        .form-group
          = f.submit 'Send confirmation email', class: 'btn btn-primary'

javascript:
  // Clear the temp email.
  $('#user_email').val("");
```


#### social_profiles_controller
- Disconnect from a social profile.

`/app/controllers/social_profiles_controller.rb`

```rb
class SocialProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user!

  def destroy
    @profile.destroy
    flash[:success] = "Disconnected from #{@profile.provider.capitalize}"
    redirect_to root_url
  end

  private

    def correct_user!
      @profile = SocialProfile.find(params[:id])
      unless @profile.user_id == current_user.id
        redirect_to root_url and return
      end
    end
end
```

#### confirmations_controller
- Allow the user for login by clicking the link in confirmation email.

`/app/controllers/confirmations_controller.rb`

```rb
class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation?confirmation_token=abcdef
  # Override
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_flashing_format?

      sign_in(resource) #<== Only this line is changed.

      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render :new }
    end
  end
end
```

#### registrations_controller

OmniAuthで認証のユーザーに対して、パスワード入力を免除させるため上書き。

`/app/controllers/registrations_controller.rb`

```rb
class Users::RegistrationsController < Devise::RegistrationsController

  protected

  # Override
  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
```


### Set up `letter_opener_web` (Optional)

- [docs](https://github.com/ryanb/letter_opener)

`Gemfile`

```rb
gem "letter_opener", :group => :development
```

Then set the delivery method in `config/environments/development.rb`

```rb
config.action_mailer.delivery_method = :letter_opener
```

Then set the route in `config/routes.rb`

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


## Testing

- [OmniAuthのテスト](http://qiita.com/mnishiguchi/items/3d6a4ec36c2237a11660)
- [email確認(confirmable)のテスト](http://qiita.com/mnishiguchi/items/ff480b681537c99daeaa)

---

## References

Devise

- [README](http://www.rubydoc.info/github/plataformatec/devise/)
- [OmniAuth: Overview](https://github.com/plataformatec/devise/wiki/OmniAuth%3A-Overview)
- [How To: Allow users to edit their account without providing a password](https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-edit-their-account-without-providing-a-password)
- [How to: Use a custom email validator with Devise](https://github.com/plataformatec/devise/wiki/How-to:-Use-a-custom-email-validator-with-Devise)
- [Allowing Unconfirmed Access](https://github.com/plataformatec/devise/wiki/How-To:-Add-:confirmable-to-Users#allowing-unconfirmed-access)
- [Create a username field in the users table](https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address#create-a-username-field-in-the-users-table)

OmniAuth

- [omniauth](https://github.com/intridea/omniauth)
- [omniauth-facebook](https://github.com/mkdynamic/omniauth-facebook)
- [omniauth-twitter](https://github.com/arunagw/omniauth-twitter)

実装技術

- [Rails 4 OmniAuth using Devise with Twitter, Facebook and Linkedin](http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/)
- [RailsでいろんなSNSとOAuth連携/ログインする方法](http://qiita.com/awakia/items/03dd68dea5f15dc46c15)
- [Rails4 で Devise と OmniAuth で、Twitter/Facebook のOAuth認証と通常フォームでの認証を併用して実装](http://easyramble.com/implement-devise-and-ominiauth-on-rails.html)
- [Clean OAuth for Rails: An Object-Oriented Approach](http://davidlesches.com/blog/clean-oauth-for-rails-an-object-oriented-approach)
- [rails で params に対して複雑な処理をするときのベストプラクティスは？](http://qa.atmarkit.co.jp/q/3005)
- [中規模Web開発のためのMVC分割とレイヤアーキテクチャ](http://qiita.com/yuku_t/items/961194a5443b618a4cac)
