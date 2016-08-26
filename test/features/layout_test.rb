require "test_helper"
# require "support/database_cleaner"
# require "support/poltergeist"

feature "layout" do

  scenario do

    visit root_path
    click_on 'Sign in with email'
    fill_in 'Email', with: "mnishiguchi@example.com"
    click_on 'Email me a link to sign in'
    assert_current_path "/"

    skip "Masa: js test not working"

    # within('#flash_message') do
    #   assert_selector '.message'
    #   find('.close').click
    #   refute_selector '.message'
    # end

  end
end
