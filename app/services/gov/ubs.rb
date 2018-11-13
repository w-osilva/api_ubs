module Gov::Ubs

  def ubs_settings
    path = "/saude/unidades-saude/unidade-basica-saude"
    @resources[:ubs] = {csv: {method: 'GET', url: path + "/ubs.csv"}}
  end

  def ubs_get_csv
    request(@resources[:ubs][:csv])
  end

end