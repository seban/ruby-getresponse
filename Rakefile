require 'rake/testtask'
require 'rake/rdoctask'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end


Rake::RDocTask.new do |rdoc|
  files =['README.rdoc', 'lib/**/*.rb']
  rdoc.rdoc_files.add(files)
  rdoc.main = "README.rdoc" # page to start on
  rdoc.title = "GetResponse JSON-RPC wrapper"
  rdoc.rdoc_dir = 'doc/rdoc' # rdoc output folder
  rdoc.options << '--line-numbers'
end
