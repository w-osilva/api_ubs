require 'rails_helper'

RSpec.describe Api::V1::UbsController, type: :controller do

  describe "#find_ubs" do
    subject(:request) { get :find_ubs }

    it "should use the model to perform the search" do
      model = class_double("Ubs").as_stubbed_const
      expect(model).to receive(:search_paginated)
      request
    end

    it "should return an object with pagination attributes" do
      request
      expect(JSON.parse(response.body)).to include(
                                             "current_page",
                                             "per_page",
                                             "total_records",
                                             "entries"
                                           )
    end
  end

end
