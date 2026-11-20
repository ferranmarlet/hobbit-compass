require "test_helper"

class AirportsControllerTest < ActionDispatch::IntegrationTest
  test "shows an airport" do
    airport = airports(:madrid)

    get "/airports/#{airport.id}"

    assert_response :success
    assert_equal({ "id" => airport.id, "iata_code" => "MAD", "name" => airport.name, "city" => "Madrid",
                   "country_code" => "ES", "time_zone" => "Europe/Madrid" }, response.parsed_body)
  end

  test "returns not found for an unknown airport" do
    get "/airports/0"

    assert_response :not_found
  end
end
