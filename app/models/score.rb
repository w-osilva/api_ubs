class Score < ApplicationRecord
  belongs_to :ubs

  extend Enumerize

  enumerize :size, in: {low: 1, medium: 2, high: 3}, predicates: true, scope: true

  enumerize :adaptation_for_seniors, in: {low: 1, medium: 2, high: 3}, predicates: true, scope: true

  enumerize :medical_equipment, in: {low: 1, medium: 2, high: 3}, predicates: true, scope: true

  enumerize :medicine, in: {low: 1, medium: 2, high: 3}, predicates: true, scope: true

end
