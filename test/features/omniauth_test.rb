require "test_helper"
require "support/omniauth_utils"
require "support/database_cleaner"

def confirmation_url(user)
  "/users/confirmation?confirmation_token=#{user.confirmation_token}"
end

feature "omniauth interface" do

  let(:email) { 'nishiguchi.masa@example.com' }

  scenario "new user signs in with email then signs in with twitter" do
    visit root_path
    assert_content page, "Hello, welcome!"

    click_on 'Sign in with email'
    assert_content page, /Enter email address to sign in/

    fill_in 'Email', with: email
    click_on 'Email me a link to sign in'
    assert_current_path "/"

    visit confirmation_url(User.last)
    assert_content page, "Dashboard for #{email}"

    click_on 'Sign out'
    assert_current_path "/"

    # Sign in with twitter.
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:twitter] = nil
    visit root_url
    set_omniauth_twitter

    find('a[href="/users/auth/twitter"]').click
    assert_content page, "Please enter your email address."

    fill_in 'Email', with: email
    click_on 'Send confirmation email'
    assert_current_path "/"

    visit confirmation_url(User.last)
    assert_content page, "Dashboard for #{email}"

    click_on 'Sign out'
    assert_current_path "/"
  end

  scenario "user signs in with twitter twice in a row" do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:twitter] = nil
    visit root_url
    set_omniauth_twitter

    find('a[href="/users/auth/twitter"]').click
    assert_content page, "Please enter your email address."

    fill_in 'Email', with: email
    click_on 'Send confirmation email'
    assert_current_path "/"

    visit confirmation_url(User.last)
    assert_content page, "Dashboard for #{email}"

    click_on 'Sign out'
    assert_current_path "/"

    # Sign in with twitter again.
    set_omniauth_twitter

    find('a[href="/users/auth/twitter"]').click
    assert_content page, "Dashboard for #{email}"
  end

end
