class Adapters::Ubs

  # data: {
  #   :vlr_latitude=>"-10.9112370014188",
  #   :vlr_longitude=>"-37.0620775222768",
  #   :cod_munic=>"280030",
  #   :cod_cnes=>"3492",
  #   :nom_estab=>"US OSWALDO DE SOUZA",
  #   :dsc_endereco=>"TV ADALTO BOTELHO",
  #   :dsc_bairro=>"GETULIO VARGAS",
  #   :dsc_cidade=>"Aracaju",
  #   :dsc_telefone=>"7931791326",
  #   :dsc_estrut_fisic_ambiencia=>"Desempenho acima da média",
  #   :dsc_adap_defic_fisic_idosos=>"Desempenho muito acima da média",
  #   :dsc_equipamentos=>"Desempenho mediano ou  um pouco abaixo da média",
  #   :dsc_medicamentos=>"Desempenho acima da média"
  # }
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
      score: {
        size: Score.parse_score(data[:dsc_estrut_fisic_ambiencia]),
        adaptation_for_seniors: Score.parse_score(data[:dsc_adap_defic_fisic_idosos]),
        medical_equipment: Score.parse_score(data[:dsc_equipamentos]),
        medicine: Score.parse_score(data[:dsc_medicamentos])
      }
    }
  end

end