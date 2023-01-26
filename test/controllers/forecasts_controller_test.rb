require "test_helper"

class ForecastsControllerTest < ActionDispatch::IntegrationTest
  test "should get show with an address as input" do
    input_address = '1 Infinite Loop, Cupertino, California'

    get forecasts_show_url, params: { address: input_address }
    assert_response :success    
  end
end
