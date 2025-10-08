require "test_helper"

module Campfire
  class WelcomeControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get show" do
      get welcome_show_url
      assert_response :success
    end
  end
end
