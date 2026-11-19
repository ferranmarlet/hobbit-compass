require "test_helper"

class AirportTest < ActiveSupport::TestCase
  def build_airport(**attributes)
    Airport.new(iata_code: "BCN", name: "Josep Tarradellas Barcelona–El Prat Airport", city: "Barcelona",
                country_code: "ES", time_zone: "Europe/Madrid", **attributes)
  end

  test "is valid with all attributes" do
    assert build_airport.valid?
  end

  test "normalizes codes to uppercase" do
    airport = build_airport(iata_code: " bcn ", country_code: "es")

    assert_equal "BCN", airport.iata_code
    assert_equal "ES", airport.country_code
  end

  test "requires a three-letter IATA code" do
    assert_not build_airport(iata_code: "BC").valid?
    assert_not build_airport(iata_code: "B1N").valid?
  end

  test "requires a unique IATA code" do
    assert_not build_airport(iata_code: airports(:madrid).iata_code).valid?
  end

  test "requires a two-letter country code" do
    assert_not build_airport(country_code: "ESP").valid?
  end

  test "requires an IANA time zone" do
    assert_not build_airport(time_zone: "+01:00").valid?
    assert_not build_airport(time_zone: "Madrid").valid?
  end

  test "requires name and city" do
    assert_not build_airport(name: "").valid?
    assert_not build_airport(city: nil).valid?
  end
end
