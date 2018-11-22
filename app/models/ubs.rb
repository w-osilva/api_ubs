require 'elasticsearch/model'

class Ubs < ApplicationRecord
  validates :name, presence: true, uniqueness: {:case_sensitive => false, scope: [:address, :city]}
  validates :geocode, presence: true
  validates :scores, presence: true

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

  def self.search_ubs_paginated(query: '*', page: 1, per_page: 10)
    search = search_ubs(query).page(page).per(per_page)
    {
      current_page: page,
      per_page: per_page,
      total_records: search.results.total,
      entries: parse_search_results(search.results)
    }
  end

  def self.search_ubs(query)
    __elasticsearch__.search(
      query: {
        multi_match: {
          query: query,
          fields: ['name', 'address', 'city', 'phone', 'geocode.lat', 'geocode.long'],
        }
      })
  end

  def self.parse_search_results(results)
    results.map do |result|
      res = result._source.deep_symbolize_keys
      res[:geocode][:lat]                    = res[:geocode][:lat].to_f
      res[:geocode][:long]                   = res[:geocode][:long].to_f
      res[:scores][:size]                    = res[:scores][:size].to_i
      res[:scores][:adaptation_for_seniors]  = res[:scores][:adaptation_for_seniors].to_i
      res[:scores][:medical_equipment]       = res[:scores][:medical_equipment].to_i
      res[:scores][:medicine]                = res[:scores][:medicine].to_i
      res
    end
  end

end
