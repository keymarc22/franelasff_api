# frozen_string_literal: true

require "rails_helper"

RSpec.describe Catalogue, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:shirts).through(:catalogue_shirts) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to have_db_column(:owner_id).of_type(:integer) }
    it { is_expected.to have_db_column(:owner_type).of_type(:string) }
  end
end
