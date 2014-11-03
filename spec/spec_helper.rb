# spec_helper.rb
#
# Created by Chirantan Mitra on 2012-11-20
# Copyright 2012-2014. All rights reserved
#
# See LICENSE for license

begin
  require 'simplecov'
  require 'coveralls'
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start do
    add_filter "/spec|test|vendor/"
  end
rescue LoadError
  puts "\nPlease install simplecov & coveralls to generate coverage report!\n\n"
end

require "minitest/autorun"
require "minitest/spec"
