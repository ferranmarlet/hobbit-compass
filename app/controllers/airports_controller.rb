class AirportsController < ApplicationController
  SERIALIZED_ATTRIBUTES = %i[id iata_code name city country_code time_zone].freeze

  def show
    airport = Airport.find(params[:id])

    render json: airport.as_json(only: SERIALIZED_ATTRIBUTES)
  end

  def create
    airport = Airport.new(airport_params)

    if airport.save
      render json: airport.as_json(only: SERIALIZED_ATTRIBUTES), status: :created, location: airport_url(airport)
    else
      render json: { errors: airport.errors }, status: :unprocessable_content
    end
  end

  private

  def airport_params
    params.expect(airport: %i[iata_code name city country_code time_zone])
  end
end
