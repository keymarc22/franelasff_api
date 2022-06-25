# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "validate relations" do
    it { is_expected.to have_many(:shirts) }
    it { is_expected.to have_many(:catalogues) }
    it { is_expected.to have_many(:stores) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :lastname }
    it { is_expected.to validate_presence_of :country }
  end
end
