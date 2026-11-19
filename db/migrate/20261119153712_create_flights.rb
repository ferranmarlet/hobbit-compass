class CreateFlights < ActiveRecord::Migration[8.1]
  def change
    create_table :flights do |t|
      t.string :flight_number, null: false
      t.references :origin, null: false, foreign_key: { to_table: :airports }
      t.references :destination, null: false, foreign_key: { to_table: :airports }
      t.datetime :departure_at, null: false
      t.datetime :arrival_at, null: false

      t.timestamps
    end
    add_check_constraint :flights, "origin_id <> destination_id", name: "flights_origin_differs_from_destination"
    add_check_constraint :flights, "arrival_at > departure_at", name: "flights_arrival_after_departure"
  end
end
