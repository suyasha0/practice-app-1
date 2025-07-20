# Ruby User Information Processing App

A simple command-line application written in Ruby that accepts a first name, last name, and ID code, validates the inputs, and then processes the data (placeholder for your business logic).

## Requirements

- Ruby 2.6 or newer (tested on Ruby 3.x)
- No external gems required (uses the Ruby standard library).

## Installation

Clone or download this repository, then make the script executable:

```bash
chmod +x main.rb
```

Alternatively, invoke it with `ruby main.rb` without changing permissions.

## Usage

```bash
# Long option names
ruby main.rb --first-name John --last-name Doe --id-code ABC123456

# Short option names
ruby main.rb -f Jane -l Smith -i XYZ789012

# Display help
ruby main.rb --help

# Display version
ruby main.rb --version
```

## Arguments

| Option                    | Description                            | Required |
| ------------------------- | -------------------------------------- | -------- |
| `-f`, `--first-name NAME` | First name of the user                 | ✅       |
| `-l`, `--last-name NAME`  | Last name of the user                  | ✅       |
| `-i`, `--id-code CODE`    | ID code (6-20 alphanumeric characters) | ✅       |
| `--version`               | Show version information and exit      | ❌       |
| `-h`, `--help`            | Show help message and exit             | ❌       |

## Validation Rules

- **Names** may contain letters, spaces, hyphens, and apostrophes (e.g., `O'Connor`, `Smith-Johnson`, `Mary Jane`).
- **ID code** must be 6-20 alphanumeric characters (letters and digits only).

Invalid inputs trigger a clear error message and a non-zero exit code.

## Running Tests

The project uses **Minitest** with simple Rake integration.

```bash
# Run all tests (recommended)
rake

# Or run without Rake
y ruby -I . -r minitest/autorun -e 'Dir.glob("test/**/*_test.rb").sort.each { |f| require f }'
```

Test suites live under the `test/` directory and cover:

- `EmployeeID` parsing & verification.
- Validation helpers in `Validators`.
- End-to-end `process_user_info` flow.

Feel free to add more cases as your business rules evolve.

## License

MIT License – see `LICENSE` for details.
