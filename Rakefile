require 'rubygems'
require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'cucumber'
require 'cucumber/rake/task'
require 'rdoc/task'
require 'ffi'
require 'rake/clean'

RSpec::Core::RakeTask.new

Cucumber::Rake::Task.new(:features)

RDoc::Task.new(:rdoc => "rdoc", :clobber_rdoc => "rdoc:clean", :rerdoc => "rdoc:force") do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  rd.options << "--title=UV.rb - libuv bindings for Ruby"
  rd.options << "--markup=tomdoc"
end

task :default => [:spec, :features]

file 'ext/libuv/uv.a' do
  Dir.chdir("ext/libuv") { |path| system "make" }
end

file "ext/libuv/uv.#{FFI::Platform::LIBSUFFIX}" => 'ext/libuv/uv.a' do
  Dir.chdir("ext/libuv") { |path| system 'libtool', '-dynamic', '-framework', 'CoreServices', '-o', "uv.#{FFI::Platform::LIBSUFFIX}", 'uv.a', '-lc' }
end

CLOBBER << 'ext/libuv/uv.a'
CLOBBER << "ext/libuv/uv.#{FFI::Platform::LIBSUFFIX}"

desc "Compile libuv from submodule"
task :libuv => ['ext/libuv/uv.a', "ext/libuv/uv.#{FFI::Platform::LIBSUFFIX}"]