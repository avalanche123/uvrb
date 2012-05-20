require 'thread'

module UV
  class Loop
    module ClassMethods
      def default
        create(UV.default_loop)
      end

      def new
        create(UV.loop_new)
      end

      def create(pointer)
        allocate.tap { |i| i.send(:initialize, FFI::AutoPointer.new(pointer, UV.method(:loop_delete))) }
      end
    end

    extend ClassMethods

    include Resource, Assertions

    def initialize(pointer)
      @pointer = pointer
    end

    def run
      check_result! UV.run(@pointer)
    end

    def run_once
      check_result! UV.run_once(@pointer)
    end

    def ref
      UV.ref(@pointer)
    end

    def unref
      UV.unref(@pointer)
    end

    def update_time
      UV.update_time(@pointer)
    end

    def now
      UV.now(@pointer)
    end

    def last_error
      err = UV.last_error(@pointer)

      Error.const_get(UV.err_name(err).to_sym).new(UV.strerror(err))
    end

    # factory methods

    def timer
      timer_ptr = UV.create_handle(:uv_timer)

      check_result! UV.timer_init(@pointer, timer_ptr)
      Timer.new(self, timer_ptr)
    end

    def tcp
      tcp_ptr = UV.create_handle(:uv_tcp)

      check_result! UV.tcp_init(@pointer, tcp_ptr)
      TCP.new(self, tcp_ptr)
    end

    def tty(io, readable = false)
      fileno = io.fileno

      assert_type(Integer, fileno, "io#fileno must return an integer file descriptor, #{fileno.inspect} given")
      assert_boolean(readable)

      tty_ptr = UV.create_handle(:uv_tty)

      check_result! UV.tty_init(@pointer, tty_ptr, fileno, readable ? 1 : 0)
      TTY.new(self, tty_ptr)
    end

    def pipe(ipc = false)
      assert_boolean(ipc, "ipc must be a Boolean")

      pipe_ptr = UV.create_handle(:uv_pipe)

      check_result! UV.pipe_init(@pointer, pipe_ptr, ipc ? 1 : 0)
      Pipe.new(self, pipe_ptr)
    end

    def prepare
      prepare_ptr = UV.create_handle(:uv_prepare)

      check_result! UV.prepare_init(@pointer, prepare_ptr)
      Prepare.new(self, prepare_ptr)
    end

    def check
      check_ptr = UV.create_handle(:uv_check)

      check_result! UV.check_init(@pointer, check_ptr)
      Check.new(self, check_ptr)
    end

    def idle
      idle_ptr = UV.create_handle(:uv_idle)

      check_result! UV.idle_init(@pointer, idle_ptr)
      Idle.new(self, idle_ptr)
    end

    def async(&block)
      async_ptr = UV.create_handle(:uv_async)
      async     = Async.new(self, async_ptr, &block)

      check_result! UV.async_init(@pointer, async_ptr, async.callback(:on_async))
      async
    end

    def to_ptr
      @pointer
    end
  end
end
