class ForecastService
  CACHE_EXPIRATION = 30.minutes

  attr_reader :geocode_service, :weather_service

  class ForecastResult
    attr_reader :address, :current_temperature, :feels_like, :high, :low, :humidity, :pressure, :description, :from_cache

    def initialize(address:, current_temperature:, feels_like:, high:, low:, humidity:, pressure:, description:, from_cache:)
      @address = address
      @current_temperature = current_temperature
      @feels_like = feels_like
      @high = high
      @low = low
      @humidity = humidity
      @pressure = pressure
      @description = description
      @from_cache = from_cache
    end

  end

  def initialize(geocode_service: GeocodeService.new, weather_service: WeatherService.new)
    @geocode_service = geocode_service
    @weather_service = weather_service
  end

  def for_address(address)
    geocode = geocode_service.call(address).geocode

    if geocode.nil?
      return ForecastResult.new(address: "Not Valid address", current_temperature: "NA", feels_like: "NA", high: "NA", low: "NA", humidity: "NA", pressure: "NA", description: "NA", from_cache: "NA")
    end

    weather_cache_key = "#{geocode.country_code}/#{geocode.postal_code}"
    weather_cache_exist = Rails.cache.exist?(weather_cache_key)

    weather = Rails.cache.fetch(weather_cache_key, expires_in: CACHE_EXPIRATION) do
      weather_service.call(geocode.latitude, geocode.longitude)
    end

    ForecastResult.new( address: address,
                        current_temperature: weather.temperature,
                        feels_like: weather.feels_like,
                        high: weather.temperature_max,
                        low: weather.temperature_min,
                        humidity: weather.humidity,
                        pressure: weather.pressure,
                        description: weather.description,
                        from_cache: weather_cache_exist)
  end
end