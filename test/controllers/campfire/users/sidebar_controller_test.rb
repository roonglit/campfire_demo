require "test_helper"

module Campfire
  class Users::SidebarControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get show" do
      get users_sidebar_show_url
      assert_response :success
    end
  end
end
