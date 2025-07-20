#!/usr/bin/env ruby
# frozen_string_literal: true

# -------------------------------------------------------------
# Command-line application to process user information.
# Takes first name, last name, and ID code as input.
# -------------------------------------------------------------

require 'optparse'
require_relative 'lib/employee_id'
require_relative 'lib/validators'

VERSION = '1.0.0'

# (regex constants relocated to Validators / EmployeeID)

# Custom error class for validation failures
class ValidationError < StandardError; end

# old validation helpers removed – handled by Validators / EmployeeID

# Valid ID code logic
# @param [String] first_name
# @param [String] last_name
# @param [String] id_code

def process_user_info(first_name, last_name, id_code)
  puts 'Processing user information:'
  puts "  First Name: #{first_name}"
  puts "  Last  Name: #{last_name}"
  puts "  ID Code:    #{id_code}"
  # Insert your domain logic here (DB persistence, API calls, etc.)
  
  id = EmployeeID.new(id_code)

  first_name_code = id.first_code
  last_name_code  = id.last_code
  year_of_joining = id.year
  month_of_joining = id.month
  num_employee     = id.employee_number
  verification_code = id.verification_digit
  puts "  First Name Code: #{first_name_code}"
  puts "  Last Name Code: #{last_name_code}"
  puts "  Year of Joining: #{year_of_joining}"
  puts "  Month of Joining: #{month_of_joining}"
  puts "  Number of Employee: #{num_employee}"
  puts "  Verification Code: #{verification_code}"

  if first_name[0, 2].upcase != first_name_code.upcase
    puts "  First Name Code does not match first two letters of first name."
    return false
  end
  if last_name[0, 2].upcase != last_name_code.upcase
    puts "  Last Name Code does not match first two letters of last name."
    return false
  end
  expected_vcode = id.expected_verification_digit
  if verification_code != expected_vcode
    puts "  Verification Code does not match."
    return false
  end
  true
end

# compute_verification_code moved into EmployeeID

# Entry point for the CLI application

def main(argv = ARGV)
  options = {}

  parser = OptionParser.new do |opts|
    opts.banner = "Usage: #{$PROGRAM_NAME} [options]"
    opts.separator ''
    opts.separator 'Options:'

    opts.on('-fNAME', '--first-name=NAME', 'First name of the user') do |value|
      options[:first_name] = value
    end

    opts.on('-lNAME', '--last-name=NAME', 'Last name of the user') do |value|
      options[:last_name] = value
    end

    opts.on('-iCODE', '--id-code=CODE', 'ID code of the user (6-20 alphanumeric characters)') do |value|
      options[:id_code] = value
    end

    opts.on('--version', 'Show version and exit') do
      puts "#{$PROGRAM_NAME} #{VERSION}"
      exit
    end

    opts.on('-h', '--help', 'Show this help message') do
      puts opts
      exit
    end
  end

  begin
    parser.parse!(argv)

    # Mandatory arguments check
    missing = %i[first_name last_name id_code].reject { |key| options[key] }
    unless missing.empty?
      raise ValidationError, "Missing required option(s): #{missing.join(', ')}"
    end

    first_name = Validators.validate_name!(options[:first_name], 'First name')
    last_name  = Validators.validate_name!(options[:last_name], 'Last name')
    id_code    = options[:id_code]

    if process_user_info(first_name, last_name, id_code)
      puts 'PASS'
      exit 0
    else
      warn 'INVESTIGATE'
      exit 1
    end
  rescue ValidationError => e
    warn "Error: #{e.message}"
    warn 'Use --help for usage.'
    exit 1
  rescue OptionParser::InvalidOption, OptionParser::MissingArgument => e
    warn "Error: #{e.message}"
    warn 'Use --help for usage.'
    exit 1
  rescue StandardError => e
    warn "✗ An unexpected error occurred: #{e.message}"
    exit 1
  end
end

if __FILE__ == $PROGRAM_NAME
  main
end 