# frozen_string_literal: true

class Store < ApplicationRecord
  has_many :shirts, dependent: :destroy
  belongs_to :owner, class_name: "User"

  validates :name, :location, presence: true
end
