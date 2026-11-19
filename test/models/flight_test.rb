require "test_helper"

class FlightTest < ActiveSupport::TestCase
  def build_flight(**attributes)
    Flight.new(flight_number: "IB6252", origin: airports(:new_york_jfk), destination: airports(:madrid),
               departure_at: Time.utc(2026, 12, 2, 0, 30), arrival_at: Time.utc(2026, 12, 2, 7, 45), **attributes)
  end

  test "is valid with all attributes" do
    assert build_flight.valid?
  end

  test "normalizes the flight number" do
    assert_equal "IB6252", build_flight(flight_number: "ib 6252").flight_number
  end

  test "requires a valid flight number" do
    assert_not build_flight(flight_number: "").valid?
    assert_not build_flight(flight_number: "IBERIA").valid?
    assert build_flight(flight_number: "U21234").valid?
  end

  test "requires origin and destination airports" do
    assert_not build_flight(origin: nil).valid?
    assert_not build_flight(destination: nil).valid?
  end

  test "requires a destination different from the origin" do
    flight = build_flight(destination: airports(:new_york_jfk))

    assert_not flight.valid?
    assert_includes flight.errors[:destination], "must be different from origin"
  end

  test "requires arrival after departure" do
    flight = build_flight(arrival_at: Time.utc(2026, 12, 1, 23, 0))

    assert_not flight.valid?
    assert_includes flight.errors[:arrival_at], "must be after departure"
  end

  test "returns departure and arrival times in each airport's time zone" do
    flight = flights(:madrid_to_new_york)

    assert_equal "2026-12-01 12:00 CET", flight.local_departure_at.strftime("%Y-%m-%d %H:%M %Z")
    assert_equal "2026-12-01 14:30 EST", flight.local_arrival_at.strftime("%Y-%m-%d %H:%M %Z")
  end

  test "airports with flights cannot be deleted" do
    airport = airports(:madrid)

    assert_not airport.destroy
    assert_includes airport.errors[:base], "Cannot delete record because dependent departing flights exist"
  end

  test "the database rejects a flight that arrives before it departs" do
    flight = build_flight(arrival_at: Time.utc(2026, 12, 1, 23, 0))

    assert_raises(ActiveRecord::StatementInvalid) { flight.save!(validate: false) }
  end
end
