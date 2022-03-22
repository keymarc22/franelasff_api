class User < ApplicationRecord
  has_many :catalogues, dependent: :destroy
  has_many :shirts, dependent: :destroy
  has_many :stores, dependent: :destroy
end
