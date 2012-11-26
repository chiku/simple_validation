# simple_validation.rb
#
# Created by Chirantan Mitra on 2012-11-20
# Copyright 2012.  All rights reserved
#
# See LICENSE for license
#
# This module adds methods to easily validate a plain ruby object
#
# Example:
#   require "simple_validation"
#
#   class AlienNumber
#     include SimpleValidation
#
#     def initialize(*digits)
#       @digits = digits
#     end
#
#     def value
#       @digits.reduce(0) {|result, digit| result + digit}
#     end
#
#     private
#
#     def digits_are_positive
#       @digits.each do |digit|
#         add_error("#{digit} is negative") unless digit > 0
#       end
#     end
#
#     def digits_are_less_than_ten
#       @digits.each do |digit|
#         add_error("#{digit} is greater than 9") unless digit < 10
#       end
#     end
#   end
#
#   valid_number = AlienNumber.new(1, 2, 3)
#   valid_number.valid? # true
#   valid_number.invalid? # false
#   valid_number.errors # []
#   valid_number.value # 6
#
#   invalid_number = AlienNumber.new(-1, 12)
#   invalid_number.valid? # false
#   invalid_number.invalid? # true
#   invalid_number.errors # ["-1 is negative", "12 is greater than 9"]
#   invalid_number.value # 11

module SimpleValidation
  def self.included(base) # :nodoc:
    base.class_eval do
      base.extend SimpleValidation::ClassMethods
    end
  end

  module ClassMethods
    # Add a validation method
    # The object to validate be able to invoke the method supplied
    #
    # Example:
    #   class AlienNumber
    #     include SimpleValidation
    #
    #     validate :digits_are_positive
    #     validate :digits_are_less_than_ten
    #   end
    def validate(method_name)
      validation_methods << method_name
    end

    # The list of all method names that validate the object
    def validation_methods # :nodoc:
      @validation_methods ||= []
    end
  end

  # Run all validations associated with the object
  def validate # :nodoc:
    unless @validated
      @validated = true
      self.class.validation_methods.each do |method_name|
        send method_name
      end
    end
  end

  # Runs all validations and returns _true_ if the object is valid
  def valid?
    validate
    errors.empty?
  end

  # Runs all validations and returns _true_ if the object is invalid
  def invalid?
    not valid?
  end

  # Adds an error to the errors collection
  def add_error(error)
    errors << error
  end

  # Adds an array of errors to the errors collection
  def add_errors(more_errors)
    errors.concat(more_errors)
  end

  # Returns an array of the current errors
  def errors
    validate
    @errors ||= []
  end
end
