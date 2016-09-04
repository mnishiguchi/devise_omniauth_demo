require "test_helper"
require "support/database_cleaner"

feature "user can close flash message by clicking on the close button" do

  scenario do
    Capybara.current_driver = Capybara.javascript_driver

    # Do invalid sign in on purpose.
    visit "users/sign_in"
    fill_in 'user_email', with: "..invalid..@..email..com.."
    fill_in 'user_password', with: "invalid_password"
    click_on 'Sign in with password'

    # Close the flash message.
    within('#flash_message') do
      assert_selector '.message', /invalid/i
      find('.close').click
      refute_selector '.message'
    end

  end
end
