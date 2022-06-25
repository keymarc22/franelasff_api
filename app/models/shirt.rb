# frozen_string_literal: true

class Shirt < ApplicationRecord
  has_many :catalogue_shirts, dependent: :destroy
  has_many :catalogues, through: :catalogue_shirts
  belongs_to :owner, class_name: "User"
  belongs_to :store

  validates :color, :size, :print, :quantity, presence: true

  after_create :set_code

  def set_code
    update(code: "0#{store_id}#{id}")
  end
end
