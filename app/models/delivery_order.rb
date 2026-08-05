class DeliveryOrder < ApplicationRecord
  belongs_to :customer
  belongs_to :address
  has_many :order_lines, dependent: :destroy
  accepts_nested_attributes_for :order_lines

  enum :order_source, { web: "web", whatsapp: "whatsapp", phone: "phone" }
  enum :status, { pending: "pending", scheduled: "scheduled", en_route: "en_route", delivered: "delivered", failed: "failed" }

  validates :order_lines, presence: true

  scope :in_district, ->(district) { joins(:address).where(addresses: { district: district }) }
  scope :on_date, ->(date) { where(created_at: date.all_day) }
end
