class GeocodeService 

  def call(address)
    response = Geocoder.search(address)
    
    generate_result(response)
  end

  private

    def generate_result(response)
      error_messages = parse_error_messages(response)
      
      if error_messages.empty?
        data = response.first.data
        geocode = OpenStruct.new.tap do |r|
          r.latitude = data["lat"].to_f
          r.longitude = data["lon"].to_f
          r.country_code = data["address"]["country_code"]
          r.postal_code = data["address"]["postcode"]
        end
        OpenStruct.new.tap do |r|
          r.success = true
          r.geocode = geocode
        end
      else
        OpenStruct.new.tap do |r|
          r.success = false
          r.error_messages = error_messages
        end
      end
    end

    def parse_error_messages(response)
      error_messages = []
      
      if !response
        error_messages = error_messages + ["Geocoder error"]
        return error_messages
      end
      
      if response.empty?
        error_messages = error_messages + ["No results"]
        return error_messages
      end

      if !response.first.data.present?
        error_messages = error_messages + ["Geocoder data error"]
        return error_messages
      end

      data = response.first.data
      if !data["lat"].present?
        error_messages = error_messages + ["latitude is missing"]
      end

      if !data["lon"].present?
        error_messages = error_messages + ["longitude is missing"]
      end

      if !data["address"].present?
        error_messages = error_messages + ["address is missing"]
        return error_messages
      end

      if !data["address"]["country_code"].present?
        error_messages = error_messages + ["country_code is missing"]
      end
      
      if !data["address"]["postcode"].present?
        error_messages = error_messages + ["postcode is missing"]
      end

      error_messages
    end

end