class Flight < ApplicationRecord
  belongs_to :origin, class_name: "Airport", inverse_of: :departing_flights
  belongs_to :destination, class_name: "Airport", inverse_of: :arriving_flights

  normalizes :flight_number, with: ->(number) { number.delete(" ").upcase }

  validates :flight_number, presence: true, format: { with: /\A[A-Z0-9]{2}\d{1,4}[A-Z]?\z/ }
  validates :departure_at, :arrival_at, presence: true
  validate :destination_differs_from_origin
  validate :arrival_after_departure

  def local_departure_at
    departure_at&.in_time_zone(origin.time_zone)
  end

  def local_arrival_at
    arrival_at&.in_time_zone(destination.time_zone)
  end

  private

  def destination_differs_from_origin
    errors.add(:destination, "must be different from origin") if origin_id.present? && origin_id == destination_id
  end

  def arrival_after_departure
    return if departure_at.blank? || arrival_at.blank?

    errors.add(:arrival_at, "must be after departure") unless arrival_at > departure_at
  end
end
