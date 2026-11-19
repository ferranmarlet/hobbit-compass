class CreateAirports < ActiveRecord::Migration[8.1]
  def change
    create_table :airports do |t|
      t.string :iata_code, limit: 3, null: false
      t.string :name, null: false
      t.string :city, null: false
      t.string :country_code, limit: 2, null: false
      t.string :time_zone, null: false

      t.timestamps
    end
    add_index :airports, :iata_code, unique: true
  end
end
