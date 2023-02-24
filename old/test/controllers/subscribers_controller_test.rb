require "test_helper"

class SubscribersControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    #get subscribers_create_url
    get root_url
    assert_response :success
  end
end
