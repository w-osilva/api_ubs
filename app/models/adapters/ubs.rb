class Adapters::Ubs

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