require 'rails_helper'

RSpec.describe Adapters::Geocode, type: :adapter do

  describe ".from_csv" do
    let(:csv_row) {
      {
        "vlr_latitude" => "-10.9112370014188",
        "vlr_longitude" => "-37.0620775222768",
        "cod_munic" => "280030",
        "cod_cnes" => "3492",
        "nom_estab" => "US OSWALDO DE SOUZA",
        "dsc_endereco" => "TV ADALTO BOTELHO",
        "dsc_bairro" => "GETULIO VARGAS",
        "dsc_cidade" => "Aracaju",
        "dsc_telefone" => "7931791326",
        "dsc_estrut_fisic_ambiencia" => "Desempenho acima da média",
        "dsc_adap_defic_fisic_idosos" => "Desempenho muito acima da média",
        "dsc_equipamentos" => "Desempenho mediano ou  um pouco abaixo da média",
        "dsc_medicamentos" => "Desempenho acima da média"
      }
    }
    subject {Adapters::Geocode.from_csv(csv_row)}

    it "should return a valid Hash with UBS attributes" do
      is_expected.to include(
                       :lat,
                       :long,
                     )
    end
  end

end
