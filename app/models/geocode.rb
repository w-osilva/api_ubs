class Geocode < ApplicationRecord
  validates :lat , numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }
  validates :long, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

  def to_s
    "#{lat.to_f},#{long.to_f}"
  end
end
