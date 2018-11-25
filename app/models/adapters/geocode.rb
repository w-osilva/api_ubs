class Adapters::Geocode

  def self.from_csv(data)
    data.deep_symbolize_keys!
    {
      lat: data[:vlr_latitude].to_f,
      long: data[:vlr_longitude].to_f
    }
  end

end