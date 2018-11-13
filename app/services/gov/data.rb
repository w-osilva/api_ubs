class Gov::Data
  include Gov::Ubs

  def self.singleton
    @client ||= new
  end

  attr_accessor :settings, :endpoints

  def initialize
    @settings = {url: "http://repositorio.dados.gov.br"}
    @resources = {}
    ubs_settings
  end

  def request(endpoint, params:{}, headers:{})
    url = @settings[:url] + endpoint[:url]
    method = endpoint[:method].downcase
    conn = Faraday.new(url: url)
    conn.send(method) do |req|
      req.params = params
      req.headers = headers
    end
  end
end