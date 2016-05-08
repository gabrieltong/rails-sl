require 'test_helper'

class MembersControllerTest < ActionController::TestCase
  test "should get info" do
    get :info
    assert_response :success
  end

  test "should get bind" do
    get :bind
    assert_response :success
  end

  test "should get bind_success" do
    get :bind_success
    assert_response :success
  end

  test "should get money" do
    get :money
    assert_response :success
  end

  test "should get recover_password" do
    get :recover_password
    assert_response :success
  end

end
