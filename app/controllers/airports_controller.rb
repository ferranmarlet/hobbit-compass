class AirportsController < ApplicationController
  def show
    airport = Airport.find(params[:id])

    render json: airport.as_json(only: %i[id iata_code name city country_code time_zone])
  end
end
