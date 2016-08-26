require "test_helper"
require "support/omniauth_utils"
# require "support/database_cleaner"

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

  let(:email) { 'nishiguchi.masa@example.com' }

  scenario "new user signs in with email then signs in with twitter" do

    OmniAuth.config.test_mode = true
    set_omniauth_twitter

    # Visit home page.
    visit root_path
    assert_content page, "Hello, welcome!"

    # Sign in with email.
    click_on 'Sign in with email'
    assert_content page, /Enter email address to sign in/i

    fill_in 'Email', with: email
    click_on 'Email me a link to sign in'
    assert_current_path "/"

    # Click on the confirmation link in the inbox.
    visit confirmation_url(User.last)
    assert_content page, "Dashboard for #{email}"
    assert_content page, flash_email_confirmed

    # Sign out.
    click_on 'Sign out'
    assert_current_path "/"

    # Sign in with twitter.
    find('a[href="/users/auth/twitter"]').click
    assert_content page, "Please enter your email address."

    fill_in 'Email', with: email
    click_on 'Send confirmation email'
    assert_current_path "/"

    # Click on the confirmation link in the inbox.
    visit confirmation_url(User.last)
    assert_content page, "Dashboard for #{email}"
    assert_content page, flash_email_confirmed

    click_on 'Sign out'
    assert_content page, flash_signed_out
    assert_current_path "/"
  end

  scenario "user signs in with twitter twice in a row" do

    OmniAuth.config.test_mode = true
    set_omniauth_twitter

    # Sign in with twitter.
    visit root_url
    find('a[href="/users/auth/twitter"]').click
    assert_content page, "Please enter your email address."

    fill_in 'Email', with: email
    click_on 'Send confirmation email'
    assert_current_path "/"

    # Click on the confirmation link in the inbox.
    visit confirmation_url(User.last)
    assert_content page, "Dashboard for #{email}"
    assert_content page, flash_email_confirmed

    # Sign out.
    click_on 'Sign out'
    assert_content page, flash_signed_out
    assert_current_path "/"

    # Sign in with twitter again.
    find('a[href="/users/auth/twitter"]').click
    assert_content page, "Dashboard for #{email}"
    assert_content page, flash_oauth_success_twitter
  end

end
