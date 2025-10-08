require "test_helper"

module Campfire
  class UsersControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get show" do
      get users_show_url
      assert_response :success
    end
  end
end
