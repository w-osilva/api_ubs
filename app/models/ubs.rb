require 'elasticsearch/model'

class Ubs < ApplicationRecord
  belongs_to :geocode
  has_one :scores, class_name: "Score", foreign_key: "ubs_id", dependent: :destroy

  validates :name, presence: true, uniqueness: {:case_sensitive => false, scope: [:address, :city]}

  # ElasticSearch
  # -------------------------------------------------------------
  include Elasticsearch::Model

  after_commit on: [:create] do
    IndexerJob.perform_later(self.class.name, :index, self.id)
  end
  after_commit on: [:update] do
    IndexerJob.perform_later(self.class.name, :update, self.id)
  end
  after_commit on: [:destroy] do
    __elasticsearch__.delete_document
  end

  def as_indexed_json(options = {})
    {
      id: id,
      name: name,
      address: address,
      city: city,
      phone: phone,
      geocode:{
        lat: geocode[:lat].to_f,
        long: geocode[:long].to_f,
      },
      scores:{
        size: scores[:size].value,
        adaptation_for_seniors: scores[:adaptation_for_seniors].value,
        medical_equipment: scores[:medical_equipment].value,
        medicine: scores[:medicine].value,
      }
    }
  end

end
