require "test_helper"

feature "Liking" do

  before do
    # Create a password-registered user in the database.
    user = User.new do |user|
      user.email        = "user@example.com"
      user.password     = "password"
      user.confirmed_at = Time.zone.now
      user.save!
    end
    # Create a few property on a client.
    client = create(:client)
    3.times do
      client.properties.create(attributes_for(:property))
    end
  end

  scenario "the test is sound" do

    # Sign in.
    visit root_path
    click_on "Sign in"
    fill_in "user_email", with: "user@example.com"
    fill_in "user_password", with: "password"
    click_on "Sign in with password"
    assert_current_path "/"

    # Visit the user's settings page.
    click_on "Settings"
    assert_current_path "/users/edit"

    # Initially no likes.
    page.refute_selector('a.liked')

    # Like a property on a property's show page.
    visit "/properties/#{Property.first.id}"
    click_on "Not liked"

    # Go back to the user's settings page.
    click_on "Settings"
    assert_current_path "/users/edit"

    # Now one item is liked.
    page.assert_selector('a.liked', count: 1)

    # Like a property on a property's show page.
    visit "/properties/#{Property.last.id}"
    click_on "Not liked"

    # Go back to the user's settings page.
    click_on "Settings"
    assert_current_path "/users/edit"

    # Now two items are liked.
    page.assert_selector('a.liked', count: 2)
  end
end
