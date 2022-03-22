# frozen_string_literal: true

require "rails_helper"

RSpec.describe Store, type: :model do
  describe "validate relations" do
    it { is_expected.to have_many(:shirts) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :location }
  end
end
