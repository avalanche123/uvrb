file "ext/libuv/libuv.#{FFI::Platform::LIBSUFFIX}" do
  Dir.chdir("ext/libuv") do |path|
    system "make libuv.#{FFI::Platform::LIBSUFFIX}"
  end
end

file "ext/libuv.#{FFI::Platform::LIBSUFFIX}" => "ext/libuv/libuv.#{FFI::Platform::LIBSUFFIX}" do
  File.symlink("libuv/libuv.#{FFI::Platform::LIBSUFFIX}", "ext/libuv.#{FFI::Platform::LIBSUFFIX}")
end

CLOBBER.include("ext/libuv/libuv.#{FFI::Platform::LIBSUFFIX}")
