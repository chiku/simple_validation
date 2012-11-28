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

* Fork it	  	
* Create your feature branch (`git checkout -b my-new-feature`)	  	
* Commit your changes (`git commit -am 'Added some feature'`)	  	
* Push to the branch (`git push origin my-new-feature`)	  	
* Create new Pull Request

Any pull request should include tests around it.

License
-------

This tool is released under the MIT license. Please refer to LICENSE for more details.
