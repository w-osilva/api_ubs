class Adapters::Ubs

  def self.from_csv(data)
    data.deep_symbolize_keys!
    {
      name: data[:nom_estab],
      address: data[:dsc_endereco],
      city: data[:dsc_cidade],
      phone: data[:dsc_telefone],
      geocode: {
        lat: data[:vlr_latitude].to_f,
        long: data[:vlr_longitude].to_f
      },
      scores: {
        size: enum_score(data[:dsc_estrut_fisic_ambiencia]),
        adaptation_for_seniors: enum_score(data[:dsc_adap_defic_fisic_idosos]),
        medical_equipment: enum_score(data[:dsc_equipamentos]),
        medicine: enum_score(data[:dsc_medicamentos])
      }
    }
  end

  def self.enum_score(val)
    case
    when val.match(/muito acima da média/) then 3
    when val.match(/acima da média/) then 2
    when val.match(/(mediano|abaixo da média)/) then 1
    else 0
    end
  end

end