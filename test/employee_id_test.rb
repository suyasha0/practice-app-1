require 'minitest/autorun'
require_relative '../lib/employee_id'

class EmployeeIDTest < Minitest::Test
  def setup
    @code = 'CAJI202002196'
    @id   = EmployeeID.new(@code)
  end

  def test_component_parsing
    assert_equal 'CA', @id.last_code
    assert_equal 'JI', @id.first_code
    assert_equal '2020', @id.year
    assert_equal '02', @id.month
    assert_equal '19', @id.employee_number
    assert_equal '6',  @id.verification_digit
  end

  def test_verification_digit_valid
    assert @id.valid_verification_digit?
  end

  def test_verification_digit_invalid
    bad = EmployeeID.new('CAJI202002199')
    refute bad.valid_verification_digit?
  end

  def test_invalid_format_raises
    assert_raises(ArgumentError) { EmployeeID.new('abcd') }
  end
end 