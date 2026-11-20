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

  def valid_airport_attributes
    { iata_code: "BCN", name: "Josep Tarradellas Barcelona–El Prat Airport", city: "Barcelona",
      country_code: "ES", time_zone: "Europe/Madrid" }
  end

  test "creates an airport" do
    assert_difference "Airport.count", 1 do
      post "/airports", params: { airport: valid_airport_attributes }, as: :json
    end

    airport = Airport.find_by!(iata_code: "BCN")
    assert_response :created
    assert_equal airport_url(airport), response.location
    assert_equal "Barcelona", response.parsed_body["city"]
  end

  test "creates an airport from unwrapped JSON attributes" do
    assert_difference "Airport.count", 1 do
      post "/airports", params: valid_airport_attributes, as: :json
    end

    assert_response :created
  end

  test "does not create an invalid airport" do
    assert_no_difference "Airport.count" do
      post "/airports", params: { airport: valid_airport_attributes.merge(iata_code: "MAD") }, as: :json
    end

    assert_response :unprocessable_content
    assert_equal [ "has already been taken" ], response.parsed_body.dig("errors", "iata_code")
  end

  test "rejects a request without airport attributes" do
    post "/airports", params: { something_else: "x" }, as: :json

    assert_response :bad_request
  end
end
