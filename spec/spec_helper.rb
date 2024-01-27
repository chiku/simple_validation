# frozen_string_literal: true

# spec_helper.rb
#
# Created by Chirantan Mitra on 2012-11-20
# Copyright 2012-2024. All rights reserved
#
# See LICENSE for license

begin
  require('coveralls')
  require('simplecov')
  ::SimpleCov.formatter = ::SimpleCov::Formatter::MultiFormatter.new(
    [
      ::SimpleCov::Formatter::HTMLFormatter,
      ::Coveralls::SimpleCov::Formatter
    ]
  )
  ::SimpleCov.start
rescue ::LoadError
  puts("\nPlease install simplecov & coveralls to generate coverage report!\n\n")
end

require 'minitest/autorun'
require 'minitest/spec'
