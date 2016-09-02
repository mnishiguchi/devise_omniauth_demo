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

feature "authentication" do

  let(:user_email) { "nishiguchi.masa@example.com" }

  scenario "New user signs up with password" do

    # Visit home page.
    visit root_path
    assert_content page, "Hello, welcome!"

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

  scenario "Registered user signs in with password then signs in with twitter" do

    OmniAuth.config.test_mode = true
    set_omniauth_twitter

    # Create a password-registered user in the database.
    User.new(email: user_email, password: "password") do |user|
      user.skip_confirmation!
      user.save!
    end

    # Visit home page.
    visit root_path
    assert_content page, "Hello, welcome!"

    # Sign in with password.
    click_on "Sign in with password"
    assert_content page, /sign in/i

    fill_in "user_email", with: user_email
    fill_in "user_password", with: "password"
    click_on "Sign in with password"
    assert_current_path "/"

    # Sign out.
    click_on "Sign out"
    assert_current_path "/"

    # Sign in with twitter for the first time.
    find('a[href="/users/auth/twitter"]').click
    assert_content page, "Please enter your email address."

    # Email confirmation.
    fill_in "Email", with: user_email
    click_on "Send confirmation email"
    assert_current_path "/"

    # Click on the confirmation link in the inbox.
    visit confirmation_url(User.last)
    assert_content page, "Dashboard for #{user_email}"
    assert_content page, flash_email_confirmed

    click_on "Sign out"
    assert_content page, flash_signed_out
    assert_current_path "/"
  end

  scenario "user signs in with twitter twice in a row" do

    OmniAuth.config.test_mode = true
    set_omniauth_twitter

    # Sign in with twitter for the first time.
    visit root_url
    find('a[href="/users/auth/twitter"]').click
    assert_content page, "Please enter your email address."

    # Email confirmation.
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
    find('a[href="/users/auth/twitter"]').click
    assert_content page, "Dashboard for #{user_email}"
    assert_content page, flash_oauth_success_twitter
  end

end
