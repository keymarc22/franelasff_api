# frozen_string_literal: true

class User < ApplicationRecord
  has_many :catalogues, dependent: :destroy, as: :owner
  has_many :shirts, dependent: :destroy, as: :owner
  has_many :stores, dependent: :destroy, as: :owner

  after_initialize :generate_auth_token

  def generate_auth_token
    # User.new
    self.auth_token = TokenGenerationService.generate if auth_token.blank?
  end
end
