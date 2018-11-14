class Ubs < ApplicationRecord
  belongs_to :geocode
  has_one :scores, class_name: "Score", foreign_key: "ubs_id", dependent: :destroy

  validates :name, presence: true, uniqueness: {:case_sensitive => false, scope: [:address, :city]}

  # ElasticSearch - https://github.com/ankane/searchkick
  # -------------------------------------------------------------
  searchkick _all: false, callbacks: :async

  scope :search_import, -> { includes(:geocode, :scores) }

  def search_data
    {
      all: [
        name,
        address,
        city,
        phone,
        geocode.to_s
      ].join(",")
    }
  end
end
