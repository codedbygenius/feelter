require "test_helper"

class MoodsControllerTest < ActionDispatch::IntegrationTest
  test "should get select" do
    get moods_select_url
    assert_response :success
  end

  test "should get create" do
    get moods_create_url
    assert_response :success
  end
end
