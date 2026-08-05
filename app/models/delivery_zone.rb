class DeliveryZone < ApplicationRecord
  enum :district, Districts::VALUES.index_by(&:itself)

  scope :active, -> { where(active: true) }

  def self.serves?(district)
    active.exists?(district: district)
  end
end
