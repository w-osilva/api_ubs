class Adapters::Ubs

  def self.from_csv(data)
    data.deep_symbolize_keys!
    {
      name: data[:nom_estab],
      address: data[:dsc_endereco],
      city: data[:dsc_cidade],
      phone: data[:dsc_telefone],
      geocode: ::Adapters::Geocode.from_csv(data),
      scores: ::Adapters::Score.from_csv(data)
    }
  end

end