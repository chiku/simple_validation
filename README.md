![Build Status](https://github.com/chiku/simple_validation/actions/workflows/build.yml/badge.svg)
[![Gem Version](https://badge.fury.io/rb/simple_validation.svg)](http://badge.fury.io/rb/simple_validation)
[![Code Climate](https://codeclimate.com/github/chiku/simple_validation.png)](https://codeclimate.com/github/chiku/simple_validation)
[![Coverage Status](https://coveralls.io/repos/chiku/simple_validation/badge.png?branch=master)](https://coveralls.io/r/chiku/simple_validation?branch=master)

Overview
--------

This is very simple gem to allow custom validations in a ruby object. You are supposed to define your validations.

Dependencies
------------

There are no runtime dependencies for this gem. This gem runs with ruby 1.9+ or compatible versions. Ruby 1.8 isn't supported.
Please use version 0.1.6 of simple_validation if you wish to use ruby 1.8.

Installation
------------

```script
gem install simple_validation
```

Usage
------

```ruby
require 'simple_validation'

class AlienNumber
  include SimpleValidation

  validate :digits_are_positive
  validate :digits_are_less_than_ten, :if => [:digits_count_even?]

  def initialize(*digits)
    @digits = digits
  end

  def value
    @digits.reduce(0) {|result, digit| result + digit}
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

valid_number = AlienNumber.new(1, 2, 3)
valid_number.valid? # true
valid_number.invalid? # false
valid_number.errors # []
valid_number.value # 6

invalid_number = AlienNumber.new(-1, 12)
invalid_number.valid? # false
invalid_number.invalid? # true
invalid_number.errors # ["-1 is negative", "12 is greater than 9"]
invalid_number.value # 11

another_invalid_number = AlienNumber.new(-10, 12, 15)
another_invalid_number.valid? # false
another_invalid_number.invalid? # true
another_invalid_number.errors # ["-10 is negative"]
another_invalid_number.value # 17
```

Running tests
-------------

1. Clone the repository.
2. Run `bundle` from the root directory.
3. Run `bundle rake` from the root directory.

License
-------

This tool is released under the MIT license. Please refer to LICENSE for more details.
