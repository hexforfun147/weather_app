require "application_system_test_case"

class ForecastsTest < ApplicationSystemTestCase
  test "show" do
    input_address = Faker::Address.full_address
    visit url_for \
      controller: "forecasts", 
      action: "show", 
      params: { 
        address: input_address 
      }
    assert_selector "h1", text: "Forecasts#show"
  end
end
