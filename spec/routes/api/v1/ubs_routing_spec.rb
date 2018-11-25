require "rails_helper"

RSpec.describe Api::V1::UbsController, :type => :routing do

  it { expect(:get => "/api/v1/find_ubs").to route_to("api/v1/ubs#find_ubs", format: :json) }

end
