# frozen_string_literal: true

require "rails_helper"

RSpec.describe Catalogue, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:shirts).through(:catalogue_shirts) }
    it { is_expected.to belong_to(:owner).class_name("User") }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :description }
  end
end
