[![Build Status](https://secure.travis-ci.org/chiku/simple_validation.png?branch=master)](https://travis-ci.org/chiku/simple_validation)

Overview
--------

This is very simple gem to allow custom validations in a ruby object. You are supposed to define your validations.

Dependencies
------------

These are no runtime dependencies for this gem. You need minitest to run the tests for this gem.

Installation
------------

``` script
gem install simple_validation
```

Usage
------

``` ruby
require "simple_validation"

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

Clone the repository and run `rake` from the root directory.

Contributing
------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, but do not mess with the VERSION. If you want to have your own version, that is fine but bump the version in a commit by itself in another branch so I can ignore it when I pull.
* Send me a pull request.

License
-------

This tool is released under the MIT license. Please refer to LICENSE for more details.
