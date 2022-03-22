# frozen_string_literal: true

class Shirt < ApplicationRecord
  has_many :catalogue_shirts, dependent: :destroy
  has_many :catalogues, through: :catalogue_shirts
  belongs_to :owner, class_name: 'User', foreign_key: "user_id"
  belongs_to :store

  validates :color, :size, :print, :code, :quantity, presence: true
  validates :code, uniqueness: { case_sensitive: false }
end
