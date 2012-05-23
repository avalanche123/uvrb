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
    def run
      check_result! UV.run(@pointer)
    end

    # Public: Runs outstanding events once, yields control back
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
    def run_once
      check_result! UV.run_once(@pointer)
    end

    # Public: Increment internal ref counter on the loop. Useful for extending the loop
    # with custom watchers that need to make loop not stop
    # 
    # Returns nothing
    def ref
      UV.ref(@pointer)
    end

    # Public: Decrement internal ref counter on the loop, useful to stop loop even when
    # there are outstanding open handles
    # 
    # Returns nothing
    def unref
      UV.unref(@pointer)
    end

    # Public: forces loop time update, useful for getting more granular times
    # 
    # Returns nothing
    def update_time
      UV.update_time(@pointer)
    end

    # Public: Get current time in microseconds
    # 
    # Returns timestamp with microseconds as an Integer
    def now
      UV.now(@pointer)
    end

    # Internal: Get last error from the loop
    # 
    # Returns one of UV::Error or nil
    def last_error
      err  = UV.last_error(@pointer)
      name = UV.err_name(err)
      msg  = UV.strerror(err)

      return nil if name == "OK"

      Error.const_get(name.to_sym).new(msg)
    end

    # Public: Get a new timer instance
    # 
    # Returns UV::Timer
    def timer
      timer_ptr = UV.create_handle(:uv_timer)

      check_result! UV.timer_init(@pointer, timer_ptr)
      Timer.new(self, timer_ptr)
    end

    # Public: Get a new TCP instance
    # 
    # Returns UV::TCP instance
    def tcp
      tcp_ptr = UV.create_handle(:uv_tcp)

      check_result! UV.tcp_init(@pointer, tcp_ptr)
      TCP.new(self, tcp_ptr)
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

      tty_ptr = UV.create_handle(:uv_tty)

      check_result! UV.tty_init(@pointer, tty_ptr, fileno, readable ? 1 : 0)
      TTY.new(self, tty_ptr)
    end

    # Public: Get a new Pipe instance
    # 
    # Returns UV::Pipe
    def pipe
      pipe_ptr = UV.create_handle(:uv_pipe)

      check_result! UV.pipe_init(@pointer, pipe_ptr, 0)
      Pipe.new(self, pipe_ptr)
    end

    # Public: Get a new IPC instance
    # 
    # Returns UV::IPC
    def ipc
      pipe_ptr = UV.create_handle(:uv_pipe)

      check_result! UV.pipe_init(@pointer, pipe_ptr, 1)
      IPC.new(self, pipe_ptr)
    end

    # Public: Get a new Prepare handle
    # 
    # Returns UV::Prepare
    def prepare
      prepare_ptr = UV.create_handle(:uv_prepare)

      check_result! UV.prepare_init(@pointer, prepare_ptr)
      Prepare.new(self, prepare_ptr)
    end

    # Public: Get a new Check handle
    # 
    # Returns UV::Check
    def check
      check_ptr = UV.create_handle(:uv_check)

      check_result! UV.check_init(@pointer, check_ptr)
      Check.new(self, check_ptr)
    end

    # Public: Get a new Idle handle
    # 
    # Returns UV::Handle
    def idle
      idle_ptr = UV.create_handle(:uv_idle)

      check_result! UV.idle_init(@pointer, idle_ptr)
      Idle.new(self, idle_ptr)
    end

    # Public: Get a new Async handle
    # 
    # Returns UV::Async
    # 
    # Raises ArgumentError if block is not given and is not expecting one argument exactly
    def async(&block)
      async_ptr = UV.create_handle(:uv_async)
      async     = Async.new(self, async_ptr, &block)

      check_result! UV.async_init(@pointer, async_ptr, async.callback(:on_async))
      async
    end

    # Internal: Get a hold of internal loop pointer instance
    # 
    # Returns FFI::Pointer
    def to_ptr
      @pointer
    end
  end
end
