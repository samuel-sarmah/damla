class Address < ApplicationRecord
  belongs_to :customer

  enum :district, Districts::VALUES.index_by(&:itself)

  validates :free_text_description, presence: true
end
