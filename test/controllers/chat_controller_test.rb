require 'test_helper'

class ChatControllerTest < ActionController::TestCase
  test "should get check" do
    get :check
    assert_response :success
  end

  test "should get auth" do
    get :auth
    assert_response :success
  end

end
