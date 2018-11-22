require 'rails_helper'

RSpec.describe Ubs, type: :model do

  context "attributes" do
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

  context "validations" do
    subject { build(:ubs) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive.scoped_to([:address, :city]) }
    it { should validate_presence_of(:geocode) }
    it { should validate_presence_of(:scores) }
  end

end
