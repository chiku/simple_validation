# simple_validation.rb
#
# Created by Chirantan Mitra on 2012-11-20
# Copyright 2012-2016. All rights reserved
#
# See LICENSE for license

##
# <b>Add methods to validate a plain ruby object</b>
#
# == Examples
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

##
# Include SimpleValidation to add methods for validating ruby objects
module SimpleValidation
  def self.included(base)
    base.class_eval do
      base.extend SimpleValidation::ClassMethods
    end
  end

  ##
  # _SimpleValiation::ClassMethod_ is extended when _SimpleValiation_ is
  # included
  module ClassMethods
    ##
    # Add a validation method
    # The object to validate should be able to invoke the method supplied
    # You can pass a list of conditions that the object must satisfy for
    # the validations to run
    #
    # Example:
    #   class AlienNumber
    #     include SimpleValidation
    #
    #     validate :digits_are_positive
    #     validate :digits_are_less_than_ten, :if => [:digits_count_even?]
    #   end
    def validate(method_name, conditions = {})
      validation_methods[method_name] = conditions[:if] || []
    end

    # The list of all method names that validate the object
    def validation_methods
      @validation_methods ||= {}
    end
  end

  # Run all validations associated with the object
  def validate
    return if @validated ||= false
    @validated = true
    self.class.validation_methods.each do |method_name, conditions|
      send method_name if conditions.all? { |condition| send condition }
    end
  end

  ##
  # Runs validations if not already run and returns _true_ if valid
  #
  # @return [true, false]
  def valid?
    validate
    all_errors.empty?
  end

  ##
  # Runs validations if not already run and returns _true_ if invalid
  #
  # @return [true, false]
  def invalid?
    !valid?
  end

  ##
  # Adds an error to the errors collection
  #
  # @param error [String] error message
  def add_error(error)
    all_errors << error
  end

  ##
  # Adds a list of errors to the errors collection
  #
  # @param errors [Array[String]] error messages
  def add_errors(errors)
    all_errors.concat(errors)
  end

  ##
  # Runs validations if not already run and returns a list of errors
  #
  # @return [Array[String]] list of errors
  def errors
    validate
    all_errors
  end

  def all_errors
    @errors ||= []
    @errors.uniq!
    @errors
  end
  private :all_errors
end
