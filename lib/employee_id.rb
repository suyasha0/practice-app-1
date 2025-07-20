# frozen_string_literal: true

# Domain object representing an employee ID code and helpers to parse
# and validate its components.
class EmployeeID
  # Accept 6–20 alphanumeric chars
  ID_REGEX = /^[A-Za-z0-9]{6,20}$/.freeze

  attr_reader :last_code, :first_code, :year, :month,
              :employee_number, :verification_digit

  # @param code [String]
  # @raise [ArgumentError] when format invalid
  def initialize(code)
    raise ArgumentError, 'ID code cannot be empty' if code.to_s.empty?
    raise ArgumentError, 'ID code format invalid' unless code.match?(ID_REGEX)

    @code = code
    parse_components!
  end

  # Expected verification digit calculated from numeric part
  # according to the O-E difference algorithm.
  # @return [String]
  def expected_verification_digit
    numeric = @code[0...-1].scan(/\d/).map(&:to_i)
    return '0' if numeric.empty?

    sum_odd  = 0
    sum_even = 0
    numeric.each_with_index { |d, i| i.even? ? sum_odd += d : sum_even += d }
    v = (sum_odd - sum_even).abs
    v %= 10 if v > 9
    v.to_s
  end

  # @return [Boolean] true when the embedded digit matches the expected one.
  def valid_verification_digit?
    verification_digit == expected_verification_digit
  end

  # String representation (original code)
  def to_s = @code

  private

  def parse_components!
    @last_code          = @code[0, 2]
    @first_code         = @code[2, 2]
    @year               = @code[4, 4]
    @month              = @code[8, 2]
    @employee_number    = @code.length > 11 ? @code[10..-2] : nil
    @verification_digit = @code[-1]
  end
end 