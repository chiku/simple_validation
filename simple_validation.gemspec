# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'simple_validation/version'

files      = Dir.glob('lib/**/*') + %w(LICENSE README.md CHANGELOG.md)
test_files = Dir.glob('spec/**/*')

Gem::Specification.new do |s|
  s.name              = 'simple_validation'
  s.version           = SimpleValidation::VERSION
  s.authors           = ['Chirantan Mitra']
  s.email             = ['chirantan.mitra@gmail.com']
  s.homepage          = 'https://github.com/chiku/simple_validation'
  s.summary           = 'Validations for a ruby object'
  s.description       = <<-EOS
Validate custom ruby objects using validation defined in the class
EOS
  s.license           = 'MIT'
  s.rubyforge_project = 'simple_validation'
  s.files             = files
  s.test_files        = test_files
  s.require_paths     = ['lib']

  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'rdoc'
end
