# frozen_string_literal: true

class User < ApplicationRecord
  has_many :catalogues, dependent: :destroy, as: :owner
  has_many :shirts, dependent: :destroy, as: :owner
  has_many :stores, dependent: :destroy, as: :owner
end
