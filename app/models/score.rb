class Score < ApplicationRecord
  belongs_to :ubs

  extend Enumerize
  enum_scores = {
    low: 1,
    normal: 2,
    high: 3
  }

  enumerize :size, in: enum_scores, predicates: true, scope: true

  enumerize :adaptation_for_seniors, in: enum_scores, predicates: true, scope: true

  enumerize :medical_equipment, in: enum_scores, predicates: true, scope: true

  enumerize :medicine, in: enum_scores, predicates: true, scope: true

end
