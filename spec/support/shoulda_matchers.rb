# frozen_string_literal: true

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    # Choose a test framework:
    with.test_framework :rspec
    # with.library :active_record
    # with.library :active_model
    # with.library :action_controller
    with.library :rails
  end
end
