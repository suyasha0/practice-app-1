# frozen_string_literal: true

# Collection of reusable validation helpers.
module Validators
  NAME_REGEX = /^[A-Za-z\s\-']+$/.freeze

  module_function

  # Validates a name, raises ValidationError on failure.
  # @param name [String]
  # @param label [String] context for error messages
  # @return [String] the original name when valid
  def validate_name!(name, label)
    raise ValidationError, "#{label} cannot be empty." if name.nil? || name.strip.empty?
    raise ValidationError, "#{label} contains invalid characters." unless name.match?(NAME_REGEX)
    name
  end
end 