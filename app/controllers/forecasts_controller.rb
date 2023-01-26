class ForecastsController < ApplicationController
  def show
    default_address = "1 Infinite Loop, Cupertino, California"
        
    if params[:address]
      @address = params[:address]
    else
      @address = default_address
    end

    forecast_service = ForecastService.new    
    @forecast_result = forecast_service.for_address(@address)
  end
end
