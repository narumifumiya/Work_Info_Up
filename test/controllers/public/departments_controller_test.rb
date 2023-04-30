require "test_helper"

class Public::DepartmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get public_departments_show_url
    assert_response :success
  end
end
