require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the templated_attribute plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the templated_attribute plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'Templated Attribute plugin documentation'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.options << '-W http://railsplugins.code.shiftcommathree.com/browser/templated_attribute/'
  rdoc.options << '--charset' << 'utf-8'
  rdoc.template = "#{ENV['template']}.rb" if ENV['template']
  rdoc.rdoc_files.include('README', 'CHANGELOG', 'MIT-LICENSE')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

