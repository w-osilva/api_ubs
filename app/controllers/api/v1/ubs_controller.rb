class Api::V1::UbsController < ApplicationController

  def find
    query = params[:query]
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    resp = Ubs.__elasticsearch__.search(
      query: {
        multi_match: {
          query: query,
          fields: ['name', 'address', 'city', 'phone', 'geocode.lat', 'geocode.long']
        }
      }
    )

    pagination = {
      current_page: page,
      per_page: per_page,
      total_records: resp.results.total,
      entries: resp.page(page).per(per_page).results.map{|res| res._source }
    }

    render json: pagination, status: :ok
  end

end
