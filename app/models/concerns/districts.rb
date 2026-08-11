module Districts
  VALUES = %w[lefkosa gazimagusa girne guzelyurt iskele lefke].freeze

  # Approximate town-center coordinates — good enough for a district-level
  # map marker, not surveyed precision (TRNC addressing isn't reliably
  # numbered/mapped, see the Address model's free_text_description field).
  COORDINATES = {
    "lefkosa" => [35.1856, 33.3823],
    "girne" => [35.3417, 33.3167],
    "gazimagusa" => [35.1264, 33.9391],
    "guzelyurt" => [35.2000, 32.9833],
    "iskele" => [35.2833, 33.8833],
    "lefke" => [35.1136, 32.8500]
  }.freeze

  # Rough center of TRNC, used to center the map before any district is picked.
  MAP_CENTER = [35.2, 33.35].freeze
end
