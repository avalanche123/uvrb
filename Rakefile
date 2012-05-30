require 'rubygems'
require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'cucumber'
require 'cucumber/rake/task'
require 'rdoc/task'
require 'ffi'
require 'rake/clean'
require 'uv/tasks'

RSpec::Core::RakeTask.new

Cucumber::Rake::Task.new(:features)

RDoc::Task.new(:rdoc => "rdoc", :clobber_rdoc => "rdoc:clean", :rerdoc => "rdoc:force") do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  rd.options << "--title=UV.rb - libuv bindings for Ruby"
  rd.options << "--markup=tomdoc"
end

task :test => [:spec, :features]
task :default => :test

desc "Compile libuv from submodule"
task :libuv => ["ext/libuv.#{FFI::Platform::LIBSUFFIX}"]

CLOBBER.include("ext/libuv.#{FFI::Platform::LIBSUFFIX}")