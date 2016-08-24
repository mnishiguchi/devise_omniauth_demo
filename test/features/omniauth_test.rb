require "test_helper"
require "support/omniauth_utils"

feature "omniauth interface" do

  before do
    @email = 'nishiguchi.masa@example.com'
  end

  test "user signs in with email" do
    visit root_path
    assert_content page, "Hello, welcome!"

    click_on 'Sign in with email'
    assert_content page, /Enter email address to sign in/

    fill_in 'Email', with: @email
    click_on 'Email me a link to sign in'
    assert_current_path "/"

    visit "/users/confirmation?confirmation_token=#{User.last.confirmation_token}"
    assert_content page, "Logged in user's dashboard"

    click_on 'Sign out'
    assert_current_path "/"
  end

  test "user signs in with twitter" do
    OmniAuth.config.test_mode = true

    visit root_url
    set_omniauth_twitter

    find('a[href="/users/auth/twitter"]').click
    assert_content page, "Please enter your email address."

    fill_in 'Email', with: @email
    click_on 'Send confirmation email'
    assert_current_path "/"

    visit "/users/confirmation?confirmation_token=#{User.last.confirmation_token}"
    assert_content page, "Logged in user's dashboard"

    click_on 'Sign out'
    assert_current_path "/"
  end

  test "user signs in with email then signs in with twitter" do
    test_user_signs_in_with_email
    test_user_signs_in_with_twitter
  end

  test "user signs in with twitter then signs in with twitter again" do
    test_user_signs_in_with_twitter

    visit root_url
    set_omniauth_twitter

    find('a[href="/users/auth/twitter"]').click
    assert_content page, "Logged in user's dashboard"
  end

end
