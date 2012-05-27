module FFI::Platform
  def self.ia32?
    ARCH == "i386"
  end

  def self.x64?
    ARCH == "x86_64"
  end
end

file 'ext/libuv/build' do
  system "git", "submodule", "update", "--init"
end

file 'ext/libuv/build/gyp' => 'ext/libuv/build' do
  system "svn", "export", "-r1214", "http://gyp.googlecode.com/svn/trunk", "ext/libuv/build/gyp"
end

CLEAN.include('ext/libuv/build/gyp')

if FFI::Platform.windows?
  require 'uv/tasks/win'
elsif FFI::Platform.mac?
  require 'uv/tasks/mac'
else # UNIX
  require 'uv/tasks/unix'
end