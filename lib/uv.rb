require 'ffi'

module UV
  extend FFI::Library
  FFI::DEBUG = 10
  ffi_lib(FFI::Library::LIBC).first
  begin
    # bias the library discovery to a path inside the gem first, then
    # to the usual system paths
    path_to_internal_libuv = File.dirname(__FILE__) + '/../ext/libuv'
    LIBUV_PATHS = [
      path_to_internal_libuv, '/usr/local/lib', '/opt/local/lib', '/usr/lib64'
    ].map{|path| "#{path}/libuv.#{FFI::Platform::LIBSUFFIX}"}
    libuv = ffi_lib(LIBUV_PATHS + %w{libuv}).first
  rescue LoadError
    warn <<-WARNING
      Unable to load this gem. The libuv library (or DLL) could not be found.
      If this is a Windows platform, make sure libuv.dll is on the PATH.
      For non-Windows platforms, make sure libuv is located in this search path:
      #{LIBUV_PATHS.inspect}
    WARNING
    exit 255
  end

  require 'uv/types'
  require 'uv/functions'

  def self.create_handle(type)
    UV.malloc(UV.handle_size(type))
  end

  def self.create_request(type)
    UV.malloc(UV.req_size(type))
  end

  autoload :Resource, 'uv/resource'
  autoload :Listener, 'uv/listener'
  autoload :Net, 'uv/net'
  autoload :Handle, 'uv/handle'
  autoload :Stream, 'uv/stream'
  autoload :Loop, 'uv/loop'
  autoload :Error, 'uv/error'
  autoload :Timer, 'uv/timer'
  autoload :TCP, 'uv/tcp'
  autoload :UDP, 'uv/udp'
  autoload :TTY, 'uv/tty'
  autoload :Pipe, 'uv/pipe'
  autoload :Prepare, 'uv/prepare'
  autoload :Check, 'uv/check'
  autoload :Idle, 'uv/idle'
  autoload :Async, 'uv/async'
  autoload :Filesystem, 'uv/filesystem'
  autoload :File, 'uv/file'
  autoload :Assertions, 'uv/assertions'
end