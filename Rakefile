require 'rubygems'
require 'rake'
require "rspec/core/rake_task"

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "on_the_spot"
    gem.summary = %Q{unobtrusive in place editing}
    gem.description = %Q{Unobtrusive in place editing, using jEditable; only works in Rails 3}
    gem.email = "nathan@dixis.com"
    gem.homepage = "http://github.com/nathanvda/on_the_spot"
    gem.authors = ["Nathan Van der Auwera", "Peter Savichev (proton)"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
    # dependencies defined in Gemfile
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end


RSpec::Core::RakeTask.new(:spec)

task :default => :spec


require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "on_the_spot #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

