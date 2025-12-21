require "test_helper"

class ContentsControllerTest < ActionDispatch::IntegrationTest
  test "should get select" do
    get contents_select_url
    assert_response :success
  end

  test "should get show" do
    get contents_show_url
    assert_response :success
  end
end
