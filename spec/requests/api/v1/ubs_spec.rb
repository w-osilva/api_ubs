require 'rails_helper'

RSpec.describe Api::V1::UbsController, :type => :request do

  describe "GET /api/v1/find_ubs" do
    it do
      get "/api/v1/find_ubs"
      expect(response).to have_http_status(:ok)
      expect(response["Content-Type"]).to include("application/json")
    end
  end

end
