# Copyright 2012-2024. All rights reserved
#
# See LICENSE for license

# frozen_string_literal: true

lib = ::File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'simple_validation/version'

files = ::Dir.glob('lib/**/*') + %w[LICENSE README.md CHANGELOG.md]

::Gem::Specification.new do |s|
  s.name              = 'simple_validation'
  s.version           = ::SimpleValidation::VERSION
  s.authors           = ['Chirantan Mitra']
  s.email             = ['chirantan.mitra@gmail.com']
  s.homepage          = 'https://github.com/chiku/simple_validation'
  s.summary           = 'Validations for a ruby object'
  s.description       = <<~DESC
    Validate custom ruby objects using validation defined in the class
  DESC
  s.license           = 'MIT'
  s.rubyforge_project = 'simple_validation'
  s.files             = files
  s.require_paths     = ['lib']
  s.required_ruby_version = '>= 2.5'
  s.metadata['rubygems_mfa_required'] = 'true'
end
