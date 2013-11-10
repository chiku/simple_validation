# spec_helper.rb
#
# Created by Chirantan Mitra on 2012-11-20
# Copyright 2012-2013. All rights reserved
#
# See LICENSE for license

begin
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec|test|vendor/"
  end
rescue LoadError
  puts "\nPlease install simplecov to generate coverage report!\n\n"
end

require "minitest/autorun"
require "minitest/spec"
