require 'thread'

module UV
  class Loop
    def self.default
      new(true)
    end

    include Resource

    def initialize(default = false)
      ptr = if default
        UV.default_loop
      else
        UV.loop_new
      end
      @pointer = FFI::AutoPointer.new(ptr, UV.method(:loop_delete))
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
      Timer.new(self)
    end

    def tcp
      TCP.new(self)
    end

    def tty(io, readable = false)
      TTY.new(self, io, readable)
    end

    def pipe(ipc = false)
      Pipe.new(self, ipc)
    end

    def prepare
      Prepare.new(self)
    end

    def check
      Check.new(self)
    end

    def idle
      Idle.new(self)
    end

    def async(&block)
      Async.new(self, &block)
    end

    def to_ptr
      @pointer
    end
  end
end
