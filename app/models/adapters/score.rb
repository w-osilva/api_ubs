class Adapters::Score

  def self.from_csv(data)
    data.deep_symbolize_keys!
    {
      size: parse_score(data[:dsc_estrut_fisic_ambiencia]),
      adaptation_for_seniors: parse_score(data[:dsc_adap_defic_fisic_idosos]),
      medical_equipment: parse_score(data[:dsc_equipamentos]),
      medicine: parse_score(data[:dsc_medicamentos])
    }
  end

  def self.parse_score(val)
    case val
    when "Desempenho mediano ou  um pouco abaixo da média" then 1
    when "Desempenho acima da média" then 2
    when "Desempenho muito acima da média" then 3
    else 0
    end
  end

end