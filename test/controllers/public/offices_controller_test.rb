require "test_helper"

class Public::OfficesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_offices_index_url
    assert_response :success
  end

  test "should get new" do
    get public_offices_new_url
    assert_response :success
  end

  test "should get edit" do
    get public_offices_edit_url
    assert_response :success
  end
end
