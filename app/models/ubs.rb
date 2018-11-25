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
  index_name "ubs-#{Rails.env}"

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

  def self.search_paginated(query: '*', page: 1, per_page: 10)
    search = __elasticsearch__.search(
      query: {
        multi_match: {
          query: query,
          fields: ['name', 'address', 'city', 'phone', 'geocode.lat', 'geocode.long'],
        }
      }
    ).page(page).per(per_page)
    {
      current_page: page,
      per_page: per_page,
      total_records: search.total_count,
      entries: parse_search_results(search)
    }
  end

  def self.parse_search_results(search)
    search.results.map do |result|
      entry = result._source.deep_symbolize_keys
      entry.slice(
        :id, :name, :city, :phone
      ).merge(
         geocode: {
           lat: entry[:geocode][:lat].to_f,
           long: entry[:geocode][:lat].to_f,
         },
         scores: {
           size: entry[:scores][:size].to_i,
           adaptation_for_seniors: entry[:scores][:adaptation_for_seniors].to_i,
           medical_equipment: entry[:scores][:medical_equipment].to_i,
           medicine: entry[:scores][:medicine].to_i,
         }
      )
    end
  end

end
