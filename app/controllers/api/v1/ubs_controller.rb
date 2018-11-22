class Api::V1::UbsController < ApplicationController
  def find_ubs
    search = Ubs.search_ubs_paginated(**find_params.to_hash.symbolize_keys)
    render json: search, status: :ok
  end

  private
  def find_params
    params.permit(:query, :page, :per_page)
  end
end
