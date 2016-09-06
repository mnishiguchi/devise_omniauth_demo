require "test_helper"

describe PropertiesController do
  include Devise::Test::ControllerHelpers
  
  test "GET index" do
    get :index
    assert_response :success
  end
end
