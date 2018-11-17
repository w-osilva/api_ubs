require 'elasticsearch/model'

class Ubs < ApplicationRecord
  belongs_to :geocode
  has_one :scores, class_name: "Score", foreign_key: "ubs_id", dependent: :destroy

  validates :name, presence: true, uniqueness: {:case_sensitive => false, scope: [:address, :city]}

  # ElasticSearch
  # -------------------------------------------------------------
  include Elasticsearch::Model

  after_commit on: [:create] do
    Gov::UbsIndexerJob.perform_later('index', self.id)
  end
  after_commit on: [:update] do
    Gov::UbsIndexerJob.perform_later('update', self.id)
  end
  after_commit on: [:destroy] do
    __elasticsearch__.delete_document
  end

  def as_indexed_json(options = {})
    self.as_json(
      only: [:id, :name, :city, :phone],
      include: {
        geocode: {
          only: [:lat, :long]
        }
      }
    ).merge(scores:{
      size: scores[:size].value,
      adaptation_for_seniors: scores[:adaptation_for_seniors].value,
      medical_equipment: scores[:medical_equipment].value,
      medicine: scores[:medicine].value,
    })
  end

  def self.parse_indexed_json(result)
    result = result._source.deep_symbolize_keys
    result[:geocode][:lat] = result[:geocode][:lat].to_f
    result[:geocode][:long] = result[:geocode][:long].to_f
    result
  end

end
