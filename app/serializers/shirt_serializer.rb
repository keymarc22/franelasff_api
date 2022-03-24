class ShirtSerializer < ActiveModel::Serializer
  attributes :id, :color, :quantity, :size, :print

  belongs_to :owner
  belongs_to :store
end
