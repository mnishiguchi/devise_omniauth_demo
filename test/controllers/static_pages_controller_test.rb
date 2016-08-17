require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  test "root should get home" do
    get root_url
    assert_response :success
    assert_template 'static_pages/home'
  end
end
