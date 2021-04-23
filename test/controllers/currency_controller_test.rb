require "test_helper"

class CurrencyControllerTest < ActionDispatch::IntegrationTest
  test "should get change" do
    get currency_change_url
    assert_response :success
  end
end
