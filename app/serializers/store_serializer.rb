# frozen_string_literal: true

class StoreSerializer < ActiveModel::Serializer
  attributes :id, :name, :location

  has_many :shirts
  belongs_to :owner
end
