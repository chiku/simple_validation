require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'
require 'yard'

Rake::TestTask.new(:test) do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

RuboCop::RakeTask.new(:lint)

# RDoc::Task.new(:rdoc) do |rdoc|
#   rdoc.rdoc_dir = 'rdoc'
#   rdoc.main = 'README.md'
#   rdoc.rdoc_files.include('README.md', 'CHANGELOG.md', 'lib/**/*.rb')
# end

YARD::Rake::YardocTask.new(:doc) do |t|
  t.files   = ['lib/**/*.rb']
  # t.options = ['--list-undoc']
end

task default: [:lint, :test, :doc]
