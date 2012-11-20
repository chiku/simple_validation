Overview
--------

This is very simple gem to allow custom validations in a ruby object. You are supposed to define your validations.

Dependencies
------------

These are no dependencies for this gem. You need minitest to run the tests for this gem.

Installation
------------

``` script
gem install easy_validation
```

Usage
------

``` ruby
require "simple_validation"

class AlienNumber
  include SimpleValidation

  validate :digits_are_positive
  validate :digits_are_less_than_ten

  def initialize(*digits)
    @digits = digits
  end

  def value
	@digits.reduce(1) {|result, digit| result + digit}
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
end

valid_number = AlienNumber.new(1, 2, 3)
valid_number.valid? # true
valid_number.invalid? # false
valid_number.errors # []

invalid_number = AlienNumber.new(-1, 12)
invalid_number.valid? # false
invalid_number.invalid? # true
invalid_number.errors # ["-1 is negative", "12 is greater than 9"]

```

Running tests
-------------

Clone the repository and run the following 'rake' from the repository.

``` script
rake
```

License
-------

This tool is released under the MIT license. Please refer to LICENSE for more details.
