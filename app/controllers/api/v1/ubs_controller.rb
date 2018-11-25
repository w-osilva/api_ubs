class Api::V1::UbsController < ApplicationController
  def find_ubs
    render json: Ubs.search_paginated(**permited_params.to_hash.symbolize_keys)
  end

  private
  def permited_params
    params.permit(:query, :page, :per_page)
  end
end
