file 'ext/libuv/out' => 'ext/libuv/build/gyp' do
  target_arch = 'ia32'if FFI::Platform.ia32?
  target_arch = 'x64' if FFI::Platform.x64?

  abort "Don't know how to build on #{FFI::Platform::ARCH} (yet)" unless target_arch

  Dir.chdir("ext/libuv") do |path|
    system "./gyp_uv -f make -Dtarget_arch=#{target_arch} -Dlibrary=shared_library -Dcomponent=shared_library"
  end
end

file "ext/libuv/out/Release/lib.target/libuv.#{FFI::Platform::LIBSUFFIX}" => 'ext/libuv/out' do
  Dir.chdir("ext/libuv") do |path|
    system 'make -C out BUILDTYPE=Release'
  end
end

file "ext/libuv.#{FFI::Platform::LIBSUFFIX}" => "ext/libuv/out/Release/lib.target/libuv.#{FFI::Platform::LIBSUFFIX}" do
  File.symlink("libuv/out/Release/lib.target/libuv.#{FFI::Platform::LIBSUFFIX}", "ext/libuv.#{FFI::Platform::LIBSUFFIX}")
end

CLEAN.include('ext/libuv/out')
CLOBBER.include("ext/libuv/out/Release/lib.target/libuv.#{FFI::Platform::LIBSUFFIX}")