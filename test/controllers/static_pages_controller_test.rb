require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get welcom" do
    get static_pages_welcom_url
    assert_response :success
  end

  test "should get manual" do
    get static_pages_manual_url
    assert_response :success
  end

end
