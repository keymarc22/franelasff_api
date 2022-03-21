# frozen_string_literal: true

class CatalogueShirt < ApplicationRecord
  belongs_to :shirt
  belongs_to :catalogue
end
