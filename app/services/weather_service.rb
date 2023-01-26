class WeatherService
  attr_reader :conn

  def initialize(service_endpoint: "https://api.openweathermap.org")
    @conn = Faraday.new(service_endpoint) do |f|
      f.request :json
      f.request :retry
      f.response :json
    end    
  end
    
  def call(latitude, longitude)
    response = conn.get('/data/2.5/weather', {
      appid: openweather_api_key,
      lat: latitude,
      lon: longitude,
      units: "metric",
    })

    body = response.body
    
    OpenStruct.new.tap do |weather|
      weather.temperature = body["main"]["temp"]
      weather.temperature_min = body["main"]["temp_min"]
      weather.temperature_max = body["main"]["temp_max"]
      weather.humidity = body["main"]["humidity"]
      weather.pressure = body["main"]["pressure"]
      weather.description = body["weather"][0]["description"]  
    end
  end

  private

    def openweather_api_key
      Rails.application.credentials.openweather_api_key || ENV["OPENWEATHER_API_KEY"]
    end
end
