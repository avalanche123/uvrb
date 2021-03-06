require 'thread'

module UV
  class Loop
    module ClassMethods
      # Public: Get default loop
      # 
      # Returns UV::Loop
      def default
        create(UV.default_loop)
      end

      # Public: Create new loop
      # 
      # Returns UV::Loop
      def new
        create(UV.loop_new)
      end

      # Internal: Create custom loop from pointer
      # 
      # Returns UV::Loop
      def create(pointer)
        allocate.tap { |i| i.send(:initialize, FFI::AutoPointer.new(pointer, UV.method(:loop_delete))) }
      end
    end

    extend ClassMethods

    include Resource, Assertions

    # Internal: Initialize a loop using an FFI::Pointer
    # 
    # Returns nothing
    def initialize(pointer) # :notnew:
      @pointer = pointer
      @loop = self
    end

    # Public: Run the actual event loop. This method will block for the duration of event loop
    # 
    # Returns nothing.
    #
    # Raises UV::Error::UNKNOWN
    # Raises UV::Error::EOF
    # Raises UV::Error::EADDRINFO
    # Raises UV::Error::EACCES
    # Raises UV::Error::EAGAIN
    # Raises UV::Error::EADDRINUSE
    # Raises UV::Error::EADDRNOTAVAIL
    # Raises UV::Error::EAFNOSUPPORT
    # Raises UV::Error::EALREADY
    # Raises UV::Error::EBADF
    # Raises UV::Error::EBUSY
    # Raises UV::Error::ECONNABORTED
    # Raises UV::Error::ECONNREFUSED
    # Raises UV::Error::ECONNRESET
    # Raises UV::Error::EDESTADDRREQ
    # Raises UV::Error::EFAULT
    # Raises UV::Error::EHOSTUNREACH
    # Raises UV::Error::EINTR
    # Raises UV::Error::EINVAL
    # Raises UV::Error::EISCONN
    # Raises UV::Error::EMFILE
    # Raises UV::Error::EMSGSIZE
    # Raises UV::Error::ENETDOWN
    # Raises UV::Error::ENETUNREACH
    # Raises UV::Error::ENFILE
    # Raises UV::Error::ENOBUFS
    # Raises UV::Error::ENOMEM
    # Raises UV::Error::ENOTDIR
    # Raises UV::Error::EISDIR
    # Raises UV::Error::ENONET
    # Raises UV::Error::ENOTCONN
    # Raises UV::Error::ENOTSOCK
    # Raises UV::Error::ENOTSUP
    # Raises UV::Error::ENOENT
    # Raises UV::Error::ENOSYS
    # Raises UV::Error::EPIPE
    # Raises UV::Error::EPROTO
    # Raises UV::Error::EPROTONOSUPPORT
    # Raises UV::Error::EPROTOTYPE
    # Raises UV::Error::ETIMEDOUT
    # Raises UV::Error::ECHARSE
    # Raises UV::Error::EAIFAMNOSUPPORT
    # Raises UV::Error::EAISERVICE
    # Raises UV::Error::EAISOCKTYPE
    # Raises UV::Error::ESHUTDOWN
    # Raises UV::Error::EEXIST
    # Raises UV::Error::ESRCH
    # Raises UV::Error::ENAMETOOLONG
    # Raises UV::Error::EPERM
    # Raises UV::Error::ELOOP
    # Raises UV::Error::EXDEV
    # Raises UV::Error::ENOTEMPTY
    # Raises UV::Error::ENOSPC
    def run(run_type = :UV_RUN_DEFAULT)
      check_result! UV.run(@pointer, run_type)

      self
    end

    # Public: (Deprecated - use loop.run with a run_type specified) Runs outstanding events once, yields control back
    # 
    # Returns nothing
    def run_once
      run(:UV_RUN_ONCE)

      self
    end

    def stop
      check_result! UV.stop(@pointer)

      self
    end

    # Public: forces loop time update, useful for getting more granular times
    # 
    # Returns nothing
    def update_time
      UV.update_time(@pointer)

      self
    end

    # Public: Get current time in microseconds
    # 
    # Returns timestamp with microseconds as an Integer
    def now
      UV.now(@pointer)
    end

    # Internal: Get last error code from the loop
    # 
    # Returns an integer error code
    def last_error
      UV.last_error(@pointer)
    end

    # Internal: Get last error from the loop
    # 
    # Returns one of UV::Error or nil
    def lookup_error(err)
      name = UV.err_name(err)
      msg  = UV.strerror(err)

      return nil if name == "OK"

      Error.const_get(name.to_sym).new(msg)
    end

    # Public: Get a new timer instance
    # 
    # Returns UV::Timer
    def timer
      timer_ptr = UV.allocate_handle_timer

      check_result! UV.timer_init(@pointer, timer_ptr)
      Timer.new(self, timer_ptr)
    end

    # Public: Get a new TCP instance
    # 
    # Returns UV::TCP instance
    def tcp
      tcp_ptr = UV.allocate_handle_tcp

      check_result! UV.tcp_init(@pointer, tcp_ptr)
      TCP.new(self, tcp_ptr)
    end

    # Public: Get a new UDP instance
    #
    # Returns UV::UDP instance
    def udp
      udp_ptr = UV.allocate_handle_udp

      check_result! UV.udp_init(@pointer, udp_ptr)
      UV::UDP.new(self, udp_ptr)
    end

    # Public: Get a new TTY instance
    # 
    # fileno   - Integer file descriptor of a tty device.
    # readable - Boolean wether TTY is readable or not
    # 
    # Returns UV::TTY
    # 
    # Raises ArgumentError if fileno argument is not an Integer
    # Raises Argument error if readable is not a Boolean
    def tty(fileno, readable = false)
      assert_type(Integer, fileno, "io#fileno must return an integer file descriptor, #{fileno.inspect} given")
      assert_boolean(readable)

      tty_ptr = UV.allocate_handle_tty

      check_result! UV.tty_init(@pointer, tty_ptr, fileno, readable ? 1 : 0)
      TTY.new(self, tty_ptr)
    end

    # Public: Get a new Pipe instance
    # 
    # ipc - Boolean wether handle will be used for ipc, useful for sharing tcp socket
    #       between processes
    # 
    # Returns UV::Pipe
    def pipe(ipc = false)
      assert_boolean(ipc)

      pipe_ptr = UV.allocate_handle_pipe

      check_result! UV.pipe_init(@pointer, pipe_ptr, ipc ? 1 : 0)
      Pipe.new(self, pipe_ptr)
    end

    # Public: Get a new Prepare handle
    # 
    # Returns UV::Prepare
    def prepare
      prepare_ptr = UV.allocate_handle_prepare

      check_result! UV.prepare_init(@pointer, prepare_ptr)
      Prepare.new(self, prepare_ptr)
    end

    # Public: Get a new Check handle
    # 
    # Returns UV::Check
    def check
      check_ptr = UV.allocate_handle_check

      check_result! UV.check_init(@pointer, check_ptr)
      Check.new(self, check_ptr)
    end

    # Public: Get a new Idle handle
    # 
    # Returns UV::Handle
    def idle
      idle_ptr = UV.allocate_handle_idle

      check_result! UV.idle_init(@pointer, idle_ptr)
      Idle.new(self, idle_ptr)
    end

    # Public: Get a new Async handle
    # 
    # Returns UV::Async
    # 
    # Raises ArgumentError if block is not given and is not expecting one argument exactly
    def async(&block)
      assert_block(block)
      assert_arity(1, block)

      async_ptr = UV.allocate_handle_async
      async     = Async.new(self, async_ptr, &block)

      check_result! UV.async_init(@pointer, async_ptr, async.callback(:on_async))
      async
    end

    # Public: Do some work in the libuv thread pool
    #
    # Returns UV::Work
    #
    # Raises ArgumentError if block is not given and if the block or optional callback are expecting any arguments
    def work(callback = nil, op = nil, &block)
      block = block || op
      assert_block(block)
      assert_arity(0, block)

      if not callback.nil?
        assert_block(callback)
        assert_arity(0, callback)
      end

      work = Work.new(self, block, callback)
    end

    # Public: Get a new Filesystem instance
    # 
    # Returns UV::Filesystem
    def fs
      Filesystem.new(self)
    end

    # Public: Get a new FSEvent instance
    # 
    # Returns UV::FSEvent
    def fs_event(path, &block)
      assert_block(block)
      assert_arity(3, block)

      fs_event_ptr = UV.allocate_handle_fs_event
      fs_event     = FSEvent.new(self, fs_event_ptr, &block)

      check_result! UV.fs_event_init(@pointer, fs_event_ptr, path, fs_event.callback(:on_fs_event), 0)
      fs_event
    end

    # Public: Get a new Signal handle
    # 
    # Returns UV::Signal
    def signal
      signal_ptr = UV.allocate_handle_signal

      check_result! UV.signal_init(@pointer, signal_ptr)
      Signal.new(self, signal_ptr)
    end

    # Internal: Get a hold of internal loop pointer instance
    # 
    # Returns FFI::Pointer
    def to_ptr
      @pointer
    end
  end
end
