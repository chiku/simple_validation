# spec_helper.rb
#
# Created by Chirantan Mitra on 2012-11-20
# Copyright 2012.  All rights reserved
#
# See LICENSE for license

begin
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
  end
rescue LoadError
  puts "\nPlease install simplecov to generate coverage report!\n\n"
end

require "minitest/autorun"
require "minitest/spec"
