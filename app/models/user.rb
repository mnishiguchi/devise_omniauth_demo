# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  email                :string           default(""), not null
#  encrypted_password   :string           default(""), not null
#  sign_in_count        :integer          default(0), not null
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :inet
#  last_sign_in_ip      :inet
#  confirmation_token   :string
#  confirmed_at         :datetime
#  confirmation_sent_at :datetime
#  unconfirmed_email    :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class User < ApplicationRecord
  has_many :social_profiles, dependent: :destroy

  # Configure devise modules.
  devise :database_authenticatable, :registerable,
         :trackable, :validatable, :confirmable, :omniauthable,
         omniauth_providers: [:facebook, :google_oauth2, :twitter]

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Validate email with a custom email validator.
  validates :email, presence: true, email: true

  # Returns a social profile object with the specified provider if any.
  def social_profile(provider)
    social_profiles.select{ |sp| sp.provider == provider.to_s }.first
  end

  # Returns true if the user has a verified email (not a temp email).
  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  # Used when we want to detect the email duplication error after form submission.
  def email_exists_in_database?
    messages = self.errors.messages
    (messages.size == 1) && (messages[:email].first == "has already been taken")
  end

  # Used when we want to detect the "already confirled" error after form submission.
  def email_already_confirmed?
    messages = self.errors.messages
    (messages.size == 1) && (messages[:email].first == "was already confirmed")
  end

  # Puts the user into the unconfirmed state.
  def reset_confirmation!
    self.update_column(:confirmed_at, nil)
  end

  # Marks the user as archived by prepending timestamp to its email.
  def archive!
    self.update_column(:email, "#{Time.now.to_i}_#{self.email}")
  end

  # Associates social profiles of another user to this user.
  def merge_social_profiles(other)
    other.social_profiles.each { |profile| profile.associate_with_user(self) }
  end

  # Merges and archives the old account.
  def merge_old_account!(old_user)
    self.merge_social_profiles(old_user) unless old_user.social_profiles.empty?
    old_user.archive!

    # Set the total sign in count on the user.
    total_sign_in_count = self.sign_in_count + old_user.sign_in_count
    self.update_column(:sign_in_count, total_sign_in_count)

    # TODO: What else do we want to merge?
  end

  # Makes current_user available via User.
  # Set up in ApplicationController.
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
    profile = SocialProfile.find_or_create_from_oauth(auth)

    # Obtain user with the following precedence.
    # 1. Logged-in user
    # 2. User with a registered profile.
    user = User.current_user || profile.user

    # 3. User with verified email from oauth.
    # If the authentication data includes verified email, search for user.
    unless user
      if auth.info.email
        user  = User.where(email: auth.info.email).first
        profile.associate_with_user(user)
      end
    end

    # 4. New user with a temp email.
    unless user
      # If user has no verified email, give the user a temp email address.
      # Later, we can detect unregistered email based on TEMP_EMAIL_PREFIX.
      # Password is not required for users with social_profiles therefore
      # it is OK to generate a random password for them.
      temp_email = "#{User::TEMP_EMAIL_PREFIX}-#{Devise.friendly_token[0,20]}.com"
      user = User.new email:    auth.info.email || temp_email,
                      password: Devise.friendly_token[0,20]
      user.tap do |u|
        # This is to postpone the delivery of confirmation email.
        u.skip_confirmation!

        # Save the temp email to database, skipping validation.
        u.save(validate: false)

        profile.associate_with_user(u)
      end
    end

    user
  end
end
