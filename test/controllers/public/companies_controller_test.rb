require "test_helper"

class Public::CompaniesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_companies_index_url
    assert_response :success
  end

  test "should get show" do
    get public_companies_show_url
    assert_response :success
  end
end
