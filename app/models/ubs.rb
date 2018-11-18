require 'elasticsearch/model'

class Ubs < ApplicationRecord
  validates :name, presence: true, uniqueness: {:case_sensitive => false, scope: [:address, :city]}

  serialize :geocode, Hash
  serialize :scores, Hash

  def geocode=(geocode)
    self[:geocode] = (geocode.deep_symbolize_keys rescue {})
  end

  def scores=(scores)
    self[:scores] = (scores.deep_symbolize_keys rescue {})
  end

  # ElasticSearch
  # -------------------------------------------------------------
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  def as_indexed_json(options = {})
    self.as_json(
      only: [:id, :name, :city, :phone]
    ).merge(
      geocode: {
        lat: geocode[:lat].to_s,
        long: geocode[:long].to_s,
      },
      scores: {
        size: scores[:size].to_s,
        adaptation_for_seniors: scores[:adaptation_for_seniors].to_s,
        medical_equipment: scores[:medical_equipment].to_s,
        medicine: scores[:medicine].to_s,
      }
    )
  end

  def self.parse_indexed_json(result)
    result = result._source.deep_symbolize_keys
    result[:geocode][:lat]                    = result[:geocode][:lat].to_f
    result[:geocode][:long]                   = result[:geocode][:long].to_f
    result[:scores][:size]                    = result[:scores][:size].to_i
    result[:scores][:adaptation_for_seniors]  = result[:scores][:adaptation_for_seniors].to_i
    result[:scores][:medical_equipment]       = result[:scores][:medical_equipment].to_i
    result[:scores][:medicine]                = result[:scores][:medicine].to_i
    result
  end

end
