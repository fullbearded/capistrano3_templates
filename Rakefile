#! /usr/bin/env rake

begin
  require 'bundler/setup'
  Bundler::GemHelper.install_tasks

rescue LoadError
  puts 'you must `gem install bundler` and `bundle install` to run rake test'
end

# Documention

require 'rdoc/task'
RDoc::Task.new(:doc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = "Capistrano 3 templates #{Capistrano3Templates::VERSION}"
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end



