require 'test_helper'

class GeocodeServiceTest < ActiveSupport::TestCase

  test "call with known address" do
    address = "1 Infinite Loop, Cupertino, California"
    result = GeocodeService.new.call(address)
    
    assert result.success
    assert_in_delta 37.33, result.geocode.latitude, 0.1
    assert_in_delta -122.03, result.geocode.longitude, 0.1
    assert_equal "us", result.geocode.country_code
    assert_equal "95014", result.geocode.postal_code
  end

end