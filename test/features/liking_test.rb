require "test_helper"

feature "Liking" do

  let(:unlike_button_css) { 'a[title="Unlike"]' }

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

  scenario "User likes a property and it is listed in the settings page" do

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
    page.refute_selector(unlike_button_css)

    # Like a property on a property's show page.
    visit "/properties/#{Property.first.id}"
    click_on "Not liked"
    visit "/users/edit"
    page.assert_selector(unlike_button_css, count: 1)

    # Like a property on a property's show page.
    visit "/properties/#{Property.last.id}"
    click_on "Not liked"
    visit "/users/edit"
    page.assert_selector(unlike_button_css, count: 2)

    # Unlike an item.
    first(unlike_button_css).click
    visit "/users/edit"
    page.assert_selector(unlike_button_css, count: 1)
  end
end
