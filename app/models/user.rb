# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ApplicationRecord
  has_many :social_profiles, dependent: :destroy

  # Configure devise modules.
  devise :database_authenticatable, :registerable,
         :trackable, :validatable, :confirmable, :omniauthable,
         :omniauth_providers => [
           :facebook,
           :google_oauth2,
           :twitter
         ]

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

  def self.find_or_create_from_oauth(auth)

    # Search for the user based on the authentication data.
    # Obtain a SocialProfile object that corresponds to the authentication data.
    profile = SocialProfile.find_from_oauth(auth)

    # Obtain user with the following precedence.
    # 1. Logged-in user
    # 2. User with a registered profile.
    user = User.current_user || profile.user

    # 3. User with verified email from oauth.
    unless user
      # If the authentication data includes verified email, search for user.
      if auth.info.email && (auth.info.verified || auth.info.verified_email)
        email = auth.info.email
        user  = User.where(email: email).first
      end
    end

    # 4. New user with a temp email.
    unless user
      # If user has no verified email, give the user a temp email address.
      # Later, we can detect unregistered email based on TEMP_EMAIL_PREFIX.
      # Password is not required for users with social_profiles therefore
      # it is OK to generate a random password for them.
      temp_email = "#{User::TEMP_EMAIL_PREFIX}-#{Devise.friendly_token[0,20]}.com"
      user = User.new(email:    email ? email : temp_email,
                      password: Devise.friendly_token[0,20] )

      # This is to postpone the delivery of confirmation email.
      user.skip_confirmation!

      # Save the temp email to database, skipping validation.
      user.save(validate: false)

      profile.associate_with_user(user)
    end

    user
  end
end
