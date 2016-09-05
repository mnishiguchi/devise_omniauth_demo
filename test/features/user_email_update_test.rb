require "test_helper"

feature "UserEmailUpdate" do

  scenario "updating email address" do

    OmniAuth.config.test_mode = true
    set_omniauth_google_oauth2

    # Sign in with google_oauth2.
    visit root_path
    find('a[href="/users/auth/google_oauth2"]').click
    assert_current_path "/"

    # Visit settings page.
    find('a[href="/users/edit"]').click
    assert_content page, /settings/i

    # Edit email address.
    within("#edit_user") do
      fill_in "user_email", with: "new-email@example.com"
      click_on "Update"
    end
    assert_content page, "You updated your account successfully, but we need to verify your new email address. Please check your email and follow the confirm link to confirm your new email address."
  end


  scenario "submitting update without editing email" do

    OmniAuth.config.test_mode = true
    set_omniauth_google_oauth2

    # Sign in with google_oauth2.
    visit root_path
    find('a[href="/users/auth/google_oauth2"]').click
    assert_current_path "/"

    # Visit settings page.
    find('a[href="/users/edit"]').click
    assert_content page, /settings/i

    # Submission withoue editing email address.
    within("#edit_user") do
      fill_in "user_email", with: User.last.social_profile(:google_oauth2).email
      click_on "Update"
    end
    assert_content page, "Your account has been updated successfully."
  end
end
