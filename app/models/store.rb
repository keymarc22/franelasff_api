# frozen_string_literal: true

class Store < ApplicationRecord
  has_many :shirts, dependent: :destroy

  validates :name, :location, presence: true
end
