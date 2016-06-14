require 'test_helper'

class CardTplsControllerTest < ActionController::TestCase
  test "should get acquire" do
    get :acquire
    assert_response :success
  end

end
