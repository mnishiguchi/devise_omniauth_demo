require 'test_helper'

describe ApplicationHelper do

  it "full_title should include the page title" do
    assert_match /\AAbout/, full_title("About")
  end

  it "full_title should include the base title" do
    assert_match /Apartment showoff\z/, full_title("About")
  end

  it "full_title should not include a separator for the home page" do
    assert_equal "Apartment showoff", full_title("")
  end
end
