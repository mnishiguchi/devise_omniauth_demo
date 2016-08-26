require "test_helper"
# require "support/database_cleaner"

feature "user can close flash message by clicking on the close button" do

  scenario do
    Capybara.current_driver = Capybara.javascript_driver

    visit root_path
    click_on 'Sign in with email'
    fill_in 'Email', with: "mnishiguchi@example.com"
    click_on 'Email me a link to sign in'
    assert_current_path "/"

    within('#flash_message') do
      assert_selector '.message'
      find('.close').click
      refute_selector '.message'
    end

  end
end
