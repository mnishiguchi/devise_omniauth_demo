# require 'test_helper'
#
# # Classic minitest.
# class StaticPagesControllerTest < ActionDispatch::IntegrationTest
#
#   test "GET home" do
#     get static_pages_home_url
#     assert_response :success
#     assert_template 'static_pages/home'
#   end
# end
#
# # Spec-style minitest.
# describe "StaticPagesController" do
#   include Devise::Test::ControllerHelpers
#
#   describe "GET home" do
#     before do
#       get :home
#     end
#
#     # Must style
#
#     it "renders static_pages/home" do
#       must_render_template "static_pages/home"
#     end
#
#     it "responds with success" do
#       must_respond_with :success
#     end
#
#     # Assert-style
#
#     it "renders static_pages/home" do
#       assert_template "static_pages/home"
#     end
#
#     it "responds with success" do
#       assert_response :success
#     end
#   end
# end
