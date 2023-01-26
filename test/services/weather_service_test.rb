require 'test_helper'

class WeatherServiceTest < ActiveSupport::TestCase

  test "call with valid location" do
    latitude, longitude = [37.33, -122.03]     
    weather = WeatherService.new.call(latitude, longitude)
    
    assert_includes -5..45, weather.temperature
    assert_includes -5..45, weather.temperature_min
    assert_includes -4..44, weather.temperature_max
    assert_includes 0..100, weather.humidity
    assert_includes 800..1200, weather.pressure
    refute weather.description.empty?
  end
end