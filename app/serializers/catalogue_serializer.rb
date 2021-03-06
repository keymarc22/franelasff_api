# frozen_string_literal: true

class CatalogueSerializer < ActiveModel::Serializer
  attributes :id, :title, :description

  has_many :shirts
  belongs_to :owner
end
