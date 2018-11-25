require 'rails_helper'

RSpec.describe Ubs, type: :model do

  describe "attributes" do
    let(:ubs) { build(:ubs) }
    subject(:attributes) { ubs.attributes.keys.map{|k| k.to_sym} }
    it { expect(attributes).to include(
      :id,
      :name,
      :address,
      :city,
      :phone,
      :geocode,
      :scores,
      :created_at,
      :updated_at
    )}
  end

  describe "validations" do
    subject { build(:ubs) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive.scoped_to([:address, :city]) }
    it { should validate_presence_of(:geocode) }
    it { should validate_presence_of(:scores) }
  end

  describe ".search_paginated" do
    before(:all) do
      create(:ubs, name: "FIRST ITEM")
      create(:ubs, name: "SECOND ITEM", geocode: { lat: "-23.604936".to_f, long: "-46.692999".to_f})
      Ubs.__elasticsearch__.create_index!(force: true); sleep 2
      Ubs.__elasticsearch__.import; sleep 2
    end

    scenario "query by name" do
      search = Ubs.search_paginated(query: "first")
      expect(search[:total_records]).to be 1
      expect(search[:entries].first[:name]).to include("FIRST ITEM")
    end

    scenario "query by geocode" do
      search = Ubs.search_paginated(query: "-23.604936,-46.692999")
      expect(search[:total_records]).to be 1
      expect(search[:entries].first[:name]).to include("SECOND ITEM")
    end
  end

end
