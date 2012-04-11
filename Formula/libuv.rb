require 'formula'

class Libuv < Formula
  homepage 'https://github.com/joyent/libuv'
  head 'https://github.com/avalanche123/libuv.git'

  if ARGV.build_head? and MacOS.xcode_version >= "4.3"
    depends_on "libtool" => :build
  end

  def options
    [
      ['--with-dylib', 'Build with libuv.dylib, useful for FFI bindings']
    ]
  end

  def install
    system "make"

    cd 'include' do
      include.install Dir['*.h']
      (include+"uv-private").install Dir['uv-private/*.h']
    end

    if ARGV.include?('--with-dylib')
      system 'libtool', '-dynamic', '-framework', 'CoreServices', '-o', 'uv.1.dylib', 'uv.a', '-lc'
      lib.install 'uv.1.dylib'
      lib.install_symlink 'uv.1.dylib' => 'uv.dylib'
    end

    lib.install 'uv.a'
  end
end
