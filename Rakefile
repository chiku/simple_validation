require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'

Rake::TestTask.new do |t|
  t.pattern = 'spec/*_spec.rb'
end

RuboCop::RakeTask.new(:lint)

task default: [:lint, :test]
