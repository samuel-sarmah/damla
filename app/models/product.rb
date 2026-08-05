class Product < ApplicationRecord
  extend Mobility
  translates :name, backend: :key_value, type: :string

  enum :unit_type, { retail_pack: "retail_pack", refillable_jug: "refillable_jug" }

  validates :sku, presence: true, uniqueness: true
  validates :size_liters, :base_price_try, presence: true

  scope :active, -> { where(is_active: true) }
  scope :ordered, -> { order(:size_liters) }
end
