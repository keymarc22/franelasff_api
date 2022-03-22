# frozen_string_literal: true

class Catalogue < ApplicationRecord
  has_many :catalogue_shirts, dependent: :destroy
  has_many :shirts, through: :catalogue_shirts
  belongs_to :owner, class_name: 'User', foreign_key: "user_id"

  validates :title, :description, presence: true
end
