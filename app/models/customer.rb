class Customer < ApplicationRecord
  enum :customer_type, { individual: "individual", business: "business" }
  enum :created_via, { web: "web", whatsapp: "whatsapp", phone: "phone", walk_in: "walk_in" }

  before_validation :normalize_phone

  validates :name, presence: true
  validates :phone, presence: true, uniqueness: true, phone: { possible: true, allow_blank: true }

  has_many :addresses, dependent: :destroy
  has_many :delivery_orders, dependent: :restrict_with_error

  private

  def normalize_phone
    return if phone.blank?

    parsed = Phonelib.parse(phone)
    self.phone = parsed.e164 if parsed.possible?
  end
end
