# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "simple_validation/version"

Gem::Specification.new do |s|
  s.name                     = "simple_validation"
  s.version                  = SimpleValidation::VERSION
  s.authors                  = ["Chirantan Mitra"]
  s.email                    = ["chirantan.mitra@gmail.com"]
  s.homepage                 = "https://github.com/chiku/simple_validation"
  s.summary                  = "Validations for a ruby object"
  s.description              = <<-EOS
A simple way to validate custom ruby objects using validation defined in the class.
EOS
  s.license                  = "MIT"
  s.rubyforge_project        = "simple_validation"
  s.files                    = Dir.glob("lib/**/*") + %w(LICENSE README.md CHANGELOG.md)
  s.test_files               = Dir.glob("spec/**/*")
  s.require_paths            = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "minitest"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "coveralls"
end
