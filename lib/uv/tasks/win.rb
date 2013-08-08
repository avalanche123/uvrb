file "ext/libuv/Release/libuv.#{FFI::Platform::LIBSUFFIX}" do
  Dir.chdir("ext/libuv") do |path|
    system 'vcbuild.bat', 'shared', 'release'
  end
end

file "ext/libuv.#{FFI::Platform::LIBSUFFIX}" => "ext/libuv/Release/libuv.#{FFI::Platform::LIBSUFFIX}" do
  FileUtils.mv("ext/libuv/Release/libuv.#{FFI::Platform::LIBSUFFIX}", "ext/libuv.#{FFI::Platform::LIBSUFFIX}")
end

CLOBBER.include("ext/libuv/Release/libuv.#{FFI::Platform::LIBSUFFIX}")
