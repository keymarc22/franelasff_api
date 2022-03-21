# frozen_string_literal: true

class Catalogue < ApplicationRecord
  has_many :catalogue_shirts, dependent: :destroy
  has_many :shirts, through: :catalogue_shirts

  validates :title, :description, presence: true
end
