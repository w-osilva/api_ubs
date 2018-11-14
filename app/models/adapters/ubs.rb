class Adapters::Ubs
  # arg data {
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
      geocode: ::Adapters::Geocode.from_csv(data.slice(
        :vlr_latitude,
        :vlr_longitude
      )),
      scores: ::Adapters::Score.from_csv(data.slice(
        :dsc_estrut_fisic_ambiencia,
        :dsc_adap_defic_fisic_idosos,
        :dsc_equipamentos,
        :dsc_medicamentos
      ))
    }
  end

end