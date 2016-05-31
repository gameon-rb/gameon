#require "bundler/gem_tasks"
require 'rake/testtask'                                                                                                                                               

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.pattern = FileList['lib/**/*.rb']
  t.pattern = FileList['spec/*_spec.rb']
  t.verbose = true
end
