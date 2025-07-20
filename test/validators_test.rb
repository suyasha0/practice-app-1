require 'minitest/autorun'
require_relative '../lib/validators'
require_relative '../main' # to get ValidationError class

class ValidatorsTest < Minitest::Test
  def test_valid_name_passes
    assert_equal 'John', Validators.validate_name!('John', 'First name')
  end

  def test_invalid_name_raises
    assert_raises(ValidationError) { Validators.validate_name!('John123', 'First name') }
  end

  def test_empty_name_raises
    assert_raises(ValidationError) { Validators.validate_name!('', 'First name') }
  end
end 