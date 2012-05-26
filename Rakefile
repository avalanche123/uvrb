require 'rubygems'
require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'cucumber'
require 'cucumber/rake/task'
require 'rdoc/task'
require 'ffi'
require 'rake/clean'

module FFI::Platform
  def self.ia32?
    ARCH == "i386"
  end

  def self.x64?
    ARCH == "x86_64"
  end
end

RSpec::Core::RakeTask.new

Cucumber::Rake::Task.new(:features)

RDoc::Task.new(:rdoc => "rdoc", :clobber_rdoc => "rdoc:clean", :rerdoc => "rdoc:force") do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  rd.options << "--title=UV.rb - libuv bindings for Ruby"
  rd.options << "--markup=tomdoc"
end

task :default => [:spec, :features]

file 'ext/libuv/build/gyp' do
  Dir.chdir("ext/libuv") { |path| system "svn", "export", "-r1214", "http://gyp.googlecode.com/svn/trunk", "build/gyp" }
end

task 'gyp_install' => 'ext/libuv/build/gyp' do
  if FFI::Platform.ia32?
    target_arch = 'ia32'
  elsif FFI::Platform.x64?
    target_arch = 'x64'
  else
    abort "cannot build on #{FFI::Platform::ARCH} architecture"
  end

  Dir.chdir("ext/libuv") do |path|
    if FFI::Platform.windows?
      system 'vcbuild.bat'
    elsif FFI::Platform.mac?
      system "./gyp_uv -f xcode -Dtarget_arch=#{target_arch}"
      system 'xcodebuild', '-project', 'uv.xcodeproj', '-configuration', 'Release', '-target', 'All'
    else # UNIX
      system "./gyp_uv -f make -Dtarget_arch=#{target_arch}"
      system 'make -C out BUILDTYPE=Release'
    end
  end
end

file 'ext/libuv/build/Release/libuv.a' => 'gyp_install'
file "ext/libuv/build/Release/libuv.#{FFI::Platform::LIBSUFFIX}" => 'gyp_install'

file 'ext/libuv/libuv.a' => 'ext/libuv/build/Release/libuv.a' do
  if FFI::Platform.windows?
    # dunno what to do yet
  elsif FFI::Platform.mac?
    File.symlink("build/Release/libuv.a", "ext/libuv/libuv.a")
  else # UNIX
    File.symlink("out/Release/obj.target/libuv.a", "ext/libuv/libuv.a")
  end
end

file "ext/libuv/libuv.#{FFI::Platform::LIBSUFFIX}" => "ext/libuv/build/Release/libuv.#{FFI::Platform::LIBSUFFIX}" do
  if FFI::Platform.windows?
    # dunno what to do yet
  elsif FFI::Platform.mac?
    File.symlink("build/Release/libuv.#{FFI::Platform::LIBSUFFIX}", "ext/libuv/libuv.#{FFI::Platform::LIBSUFFIX}")
  else # UNIX
    File.symlink("out/Release/lib.target/libuv.#{FFI::Platform::LIBSUFFIX}", "ext/libuv/libuv.#{FFI::Platform::LIBSUFFIX}")
  end
end

CLOBBER << 'ext/libuv/libuv.a'
CLOBBER << "ext/libuv/libuv.#{FFI::Platform::LIBSUFFIX}"
CLOBBER << 'ext/libuv/build/Release'
CLOBBER << 'ext/libuv/build/uv.build'
CLOBBER << 'ext/libuv/uv.xcodeproj'
# CLOBBER << 'ext/libuv/build/gyp'


desc "Compile libuv from submodule"
task :libuv => ['ext/libuv/libuv.a', "ext/libuv/libuv.#{FFI::Platform::LIBSUFFIX}"]