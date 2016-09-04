require "test_helper"

feature "social connect" do

  let(:email) { 'nishiguchi.masa@example.com' }

  scenario "connecting to twitter after signed in with email" do
    OmniAuth.config.test_mode = true

    set_omniauth_google_oauth2
    set_omniauth_twitter
    set_omniauth_facebook

    # Sign in with password.
    visit root_path
    click_on 'Sign up'
    fill_in 'Email', with: email
    fill_in 'user_password', with: "password"
    fill_in 'user_password_confirmation', with: "password"
    click_on "Email me a link to sign in"
    assert_current_path "/"

    # Click on the confirmation link.
    visit confirmation_url(User.last)
    assert_content page, "Dashboard for #{email}"

    # Visit the setting page.
    click_on "Settings"

    # Connect to Twitter.
    find(".btn-connect.twitter").click
    assert_selector ".btn-disconnect.twitter"
    assert_content page, /connected to Twitter/i

    # Connect to Google.
    find(".btn-connect.google_oauth2").click
    assert_selector ".btn-disconnect.google_oauth2"
    assert_content page, /connected to Google/i

    # Connect to Facebook.
    find(".btn-connect.facebook").click
    assert_selector ".btn-disconnect.facebook"
    assert_content page, /connected to Facebook/i

    # Disconnect from Twitter.
    find(".btn-disconnect.twitter").click
    assert_selector ".btn-connect.twitter"
    assert_content page, /disconnected from Twitter/i

    # Disconnect from Google.
    find(".btn-disconnect.google_oauth2").click
    assert_selector ".btn-connect.google_oauth2"
    assert_content page, /disconnected from Google/i

    # Disconnect from Facebook.
    find(".btn-disconnect.facebook").click
    assert_selector ".btn-connect.facebook"
    assert_content page, /disconnected from Facebook/i
  end
end
