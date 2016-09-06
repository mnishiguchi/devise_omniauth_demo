require "test_helper"
require "support/omniauth_utils"

def confirmation_url(user)
  "/users/confirmation?confirmation_token=#{user.confirmation_token}"
end

def flash_email_confirmed
  /successfully confirmed/i
end

def flash_signed_out
 /signed out/i
end

def flash_oauth_success_twitter
 "Successfully authenticated from Twitter account."
end

def flash_oauth_success_google
 "Successfully authenticated from Google account."
end


feature "user authentication" do

  let(:user_email) { "nishiguchi.masa@example.com" }

  scenario "new user signs up with password" do

    # Visit home page.
    visit root_path
    assert_content page, "Hello, welcome"

    # Sign up with password.
    click_on "Sign up"
    assert_content page, /sign up/i

    fill_in "user_email", with: user_email
    fill_in "user_password", with: "password"
    fill_in "user_password_confirmation", with: "password"
    click_on "Email me a link to sign in"
    assert_current_path "/"

    # Click on the confirmation link in the inbox.
    visit confirmation_url(User.last)
    assert_content page, "Dashboard for #{user_email}"
    assert_content page, flash_email_confirmed

    # Sign out.
    click_on "Sign out"
    assert_current_path "/"
  end


  scenario "password-registered user signs in then signs in with twitter" do

    OmniAuth.config.test_mode = true
    set_omniauth_twitter

    # Create a password-registered user in the database.
    User.new do |user|
      user.email        = user_email
      user.password     = "password"
      user.confirmed_at = Time.zone.now
      user.save!
    end

    # Visit home page.
    visit root_path
    assert_content page, "Hello, welcome"

    # Sign in.
    click_on "Sign in"
    assert_content page, /sign in/i

    fill_in "user_email", with: user_email
    fill_in "user_password", with: "password"
    click_on "Sign in with password"
    assert_current_path "/"

    # Sign out.
    click_on "Sign out"
    assert_current_path "/"

    # Sign in with twitter for the first time.
    click_on "Sign in"
    find('a[href="/users/auth/twitter"]').click
    assert_content page, "Please enter your email address."

    # Email confirmation because the oauth did not contain email.
    fill_in "Email", with: user_email
    click_on "Send confirmation email"
    assert_current_path "/"

    # Click on the confirmation link in the inbox.
    visit confirmation_url(User.last)
    assert_content page, "Dashboard for #{user_email}"
    assert_content page, flash_email_confirmed

    # Click on the confirmation again.
    visit confirmation_url(User.last)
    assert_content page, "Error confirming email. Please sign in again."

    # Sign out.
    click_on "Sign out"
    assert_content page, flash_signed_out
    assert_current_path "/"
  end


  scenario "password-registered user signs in then signs in with google" do

    OmniAuth.config.test_mode = true
    set_omniauth_google_oauth2

    # Create a password-registered user in the database.
    User.new do |user|
      user.email        = user_email
      user.password     = "password"
      user.confirmed_at = Time.zone.now
      user.save!
    end

    # Visit home page.
    visit root_path

    # Sign in.
    click_on "Sign in"
    assert_content page, /sign in/i

    fill_in "user_email", with: user_email
    fill_in "user_password", with: "password"
    click_on "Sign in with password"
    assert_current_path "/"

    # Sign out.
    click_on "Sign out"
    assert_current_path "/"

    # Sign in with google_oauth2 for the first time.
    click_on "Sign in"
    find('a[href="/users/auth/google_oauth2"]').click
    assert_current_path "/"
    assert_content page, User.last.social_profile(:google_oauth2).email
  end


  scenario "user signs in with twitter twice in a row" do

    OmniAuth.config.test_mode = true
    set_omniauth_twitter

    # Sign in with twitter for the first time.
    visit root_url
    click_on "Sign in"
    find('a[href="/users/auth/twitter"]').click
    assert_content page, "Please enter your email address."

    # Email confirmation because the oauth did not contain email.
    fill_in "Email", with: user_email
    click_on "Send confirmation email"
    assert_current_path "/"

    # Click on the confirmation link in the inbox.
    visit confirmation_url(User.last)
    assert_content page, "Dashboard for #{user_email}"
    assert_content page, flash_email_confirmed

    # Sign out.
    click_on "Sign out"
    assert_content page, flash_signed_out
    assert_current_path "/"

    # Sign in with twitter again.
    click_on "Sign in"
    find('a[href="/users/auth/twitter"]').click
    assert_content page, "Dashboard for #{user_email}"
    assert_content page, flash_oauth_success_twitter
  end


  scenario "user can skip email confirmation if oauth contails email" do

    OmniAuth.config.test_mode = true
    set_omniauth_google_oauth2

    # Sign in with google_oauth2 for the first time.
    visit root_url
    click_on "Sign in"
    find('a[href="/users/auth/google_oauth2"]').click

    # Assuming that Google OAuth contains email address.
    refute_content page, "Please enter your email address."
    assert_content page, flash_oauth_success_google

    # Sign out.
    click_on "Sign out"
    assert_content page, flash_signed_out
    assert_current_path "/"

    # Sign in with google_oauth2 again.
    click_on "Sign in"
    find('a[href="/users/auth/google_oauth2"]').click
    assert_content page, "Dashboard"
    assert_content page, flash_oauth_success_google
  end
end
