![Build Status](https://github.com/chiku/simple_validation/actions/workflows/build.yml/badge.svg)
[![Gem Version](https://badge.fury.io/rb/simple_validation.svg)](http://badge.fury.io/rb/simple_validation)

# SimpleValidation

**SimpleValidation** is a lightweight Ruby gem for defining custom validations in plain Ruby objects. It lets you express validation logic cleanly without any external dependencies.

---

## Features

- Define custom validation methods directly in your class
- Conditional validations with `:if`
- Compatible with Ruby 1.9+ (Use v0.1.6 for Ruby 1.8)

---

## Installation

```bash
gem install simple_validation
```

---

## Usage

```ruby
require 'simple_validation'

class AlienNumber
  include SimpleValidation

  validate :digits_are_positive
  validate :digits_are_less_than_ten, if: [:digits_count_even?]

  def initialize(*digits)
    @digits = digits
  end

  def value
    @digits.sum
  end

  private

  def digits_are_positive
    @digits.each do |digit|
      add_error("#{digit} is negative") unless digit > 0
    end
  end

  def digits_are_less_than_ten
    @digits.each do |digit|
      add_error("#{digit} is greater than 9") unless digit < 10
    end
  end

  def digits_count_even?
    @digits.size.even?
  end
end

# Example usage:

valid_number = AlienNumber.new(1, 2, 3)
valid_number.valid?         # => true
valid_number.errors         # => []
valid_number.value          # => 6

invalid_number = AlienNumber.new(-1, 12)
invalid_number.valid?       # => false
invalid_number.errors       # => ["-1 is negative", "12 is greater than 9"]
invalid_number.value        # => 11

odd_count_invalid = AlienNumber.new(-10, 12, 15)
odd_count_invalid.valid?    # => false
odd_count_invalid.errors    # => ["-10 is negative"]
odd_count_invalid.value     # => 17
```

---

## Running Tests

```bash
git clone https://github.com/chiku/simple_validation.git
cd simple_validation
bundle install
bundle exec rake
```

---

## License

This gem is released under the [MIT License](./LICENSE).
