require 'rubygems'
require 'rake'
require "rspec/core/rake_task"
require 'erb'
require 'JSON'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "on_the_spot"
    gem.summary = %Q{unobtrusive in place editing}
    gem.description = %Q{Unobtrusive in place editing, using jEditable; only works in Rails 3}
    gem.email = "nathan@dixis.com"
    gem.homepage = "http://github.com/nathanvda/on_the_spot"
    gem.authors = ["Nathan Van der Auwera"]
    gem.add_development_dependency "rspec", ">= 2.6.0"
    gem.add_development_dependency "actionpack", ">= 3.0.0"
    gem.add_dependency "json_pure", ">= 1.4.6"
    gem.licenses = ["MIT"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end


require 'bundler/gem_tasks'

spec = Bundler.load_gemspec('./on_the_spot.gemspec')


npm_src_dir = './npm'
npm_dest_dir = './dist'
CLOBBER.include 'dist'

assets_dir = './app/assets/'

npm_files = {
    File.join(npm_dest_dir, 'on_the_spot_code.js') => File.join(assets_dir, 'javascripts', 'on_the_spot_code.js'),
    File.join(npm_dest_dir, 'on_the_spot.css') => File.join(assets_dir, 'stylesheets', 'on_the_spot.css'),
    File.join(npm_dest_dir, 'README.md') => File.join(npm_src_dir, 'README.md'),
    File.join(npm_dest_dir, 'LICENSE') => './LICENSE'
}

namespace :npm do
  npm_files.each do |dest, src|
    file dest => src do
      cp src, dest
    end
  end

  task :'package-json' do
    template = ERB.new(File.read(File.join(npm_src_dir, 'package.json.erb')))
    content = template.result_with_hash(spec: spec)
    File.write(File.join(npm_dest_dir, 'package.json'),
               JSON.pretty_generate(JSON.parse(content)))
  end

  desc "Build nathanvda-on_the_spot-#{spec.version}.tgz into the pkg directory"
  task build: (%i[package-json] + npm_files.keys) do
    system("cd #{npm_dest_dir} && npm pack && mv ./nathanvda-on_the_spot-#{spec.version}.tgz ../pkg/")
  end

  desc "Build and push nathanvda-on_the_spot-#{spec.version}.tgz to https://npmjs.org"
  task release: %i[build] do
    system("npm publish ./pkg/nathanvda-on_the_spot-#{spec.version}.tgz --access public")
  end
end



RSpec::Core::RakeTask.new(:spec)

task :default => :spec


require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "on_the_spot #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

