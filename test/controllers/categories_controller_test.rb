require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get select" do
    get categories_select_url
    assert_response :success
  end
end
