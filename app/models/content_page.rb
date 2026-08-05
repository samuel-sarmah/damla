class ContentPage < ApplicationRecord
  extend Mobility
  translates :title, backend: :key_value, type: :string
  translates :body, backend: :key_value, type: :text

  validates :slug, presence: true, uniqueness: true
end
