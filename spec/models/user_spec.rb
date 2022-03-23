# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "validate relations" do
    it { is_expected.to have_many(:shirts) }
    it { is_expected.to have_many(:catalogues) }
    it { is_expected.to have_many(:stores) }
  end
end
