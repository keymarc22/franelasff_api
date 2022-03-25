# frozen_string_literal: true

require "rails_helper"

RSpec.describe Shirt, type: :model do

  it { is_expected.to have_db_column(:color).of_type(:string) }
  it { is_expected.to have_db_column(:size).of_type(:string) }
  it { is_expected.to have_db_column(:quantity).of_type(:integer) }
  it { is_expected.to have_db_column(:print).of_type(:string) }
  it { is_expected.to have_db_column(:owner_id).of_type(:integer) }

  describe "validate relations" do
    it { is_expected.to have_many(:catalogues).through(:catalogue_shirts) }
    it { is_expected.to belong_to(:store) }
    it { is_expected.to belong_to(:owner).class_name("User") }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :color }
    it { is_expected.to validate_presence_of :size }
    it { is_expected.to validate_presence_of :print }
    it { is_expected.to validate_presence_of :quantity }
  end

  describe "call_backs" do
    describe "#set_code" do
      it "should assign code after_create" do
        shirt = create(:shirt)
        expect(shirt.code).to_not eq(nil)
      end
    end
  end
end
