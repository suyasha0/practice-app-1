require 'minitest/autorun'
require 'stringio'
require_relative '../main'
require_relative '../lib/employee_id'

class MainTest < Minitest::Test
  # Captures STDOUT/STDERR and returns the block's value.
  def capture_io
    out, err = StringIO.new, StringIO.new
    original_stdout, original_stderr = $stdout, $stderr
    $stdout = out
    $stderr = err
    result = yield
    [result, out.string, err.string]
  ensure
    $stdout = original_stdout
    $stderr = original_stderr
  end

  # Convenience helpers
  def assert_process(first_name, last_name, id_code, expected: true)
    result, _out, _err = capture_io { process_user_info(first_name, last_name, id_code) }
    expected ? assert(result) : refute(result)
  end

  def test_compute_verification_code_basic
    assert_equal '6', EmployeeID.new('CAJI202002196').expected_verification_digit
  end

  def test_compute_verification_code_zero
    assert_equal '0', EmployeeID.new('ABCDEFZ').expected_verification_digit
  end

  def test_process_user_info_success
    assert_process('John', 'Doe', 'DOJO202002196', expected: true)
  end

  def test_process_user_info_first_name_case_insensitive_match
    assert_process('Jake', 'Doe', 'DOJa202002196', expected: true)
  end

  def test_process_user_info_first_name_mismatch
    assert_process('Jake', 'Doe', 'DOJO202002196', expected: false)
  end

  def test_process_user_info_last_name_mismatch
    assert_process('John', 'Roe', 'DOJO202002196', expected: false)
  end

  def test_process_user_info_verification_mismatch
    assert_process('John', 'Doe', 'DOJO202002199', expected: false)
  end
end 