# frozen_string_literal: true

require "rails_helper"

RSpec.describe Shirt, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:catalogues).through(:catalogue_shirts) }
    it { is_expected.to belong_to(:store) }
  end

  describe "validations" do
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
    it { is_expected.to validate_presence_of :color }
    it { is_expected.to validate_presence_of :code }
    it { is_expected.to validate_presence_of :size }
    it { is_expected.to validate_presence_of :print }
    it { is_expected.to validate_presence_of :quantity }
  end
end
