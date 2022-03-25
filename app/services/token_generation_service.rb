# frozen_string_literal: true

class TokenGenerationService
  # class method
  def self.generate
    SecureRandom.hex
  end
end
