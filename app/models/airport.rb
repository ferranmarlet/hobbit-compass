class Airport < ApplicationRecord
  normalizes :iata_code, :country_code, with: ->(code) { code.strip.upcase }

  validates :iata_code, presence: true, format: { with: /\A[A-Z]{3}\z/ }, uniqueness: true
  validates :name, :city, presence: true
  validates :country_code, presence: true, format: { with: /\A[A-Z]{2}\z/ }
  validates :time_zone, presence: true, inclusion: { in: TZInfo::Timezone.all_identifiers }
end
