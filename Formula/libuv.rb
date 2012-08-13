require 'formula'

class Libuv < Formula
  homepage 'https://github.com/joyent/libuv'
  head 'https://github.com/avalanche123/libuv.git'

  def install
    system "svn", "co", "http://gyp.googlecode.com/svn/trunk", "build/gyp"
    system './gyp_uv -f xcode -Dtarget_arch=x64'
    system 'xcodebuild', '-project', 'uv.xcodeproj', '-configuration', 'Release', '-target', 'All'

    cd 'include' do
      include.install Dir['*.h']
      (include+"uv-private").install Dir['uv-private/*.h']
    end

    lib.install 'build/Release/libuv.a'
    lib.install 'build/Release/libuv.dylib'
  end
end
