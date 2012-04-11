require 'thread'

module UV
  class Loop
    def self.default
      @default ||= allocate.tap do |i|
        i.instance_variable_set(:@pointer, FFI::AutoPointer.new(UV.default_loop, UV.method(:loop_delete)))
      end
    end

    include Resource

    def initialize
      @pointer = FFI::AutoPointer.new(UV.loop_new, UV.method(:loop_delete))
    end

    def run
      check_result UV.run(@pointer) unless @pointer.null?
    end

    def run_once
      check_result UV.run_once(@pointer) unless @pointer.null?
    end

    def ref
      UV.ref(@pointer) unless @pointer.null?
    end

    def unref
      UV.unref(@pointer) unless @pointer.null?
    end

    def update_time
      UV.update_time(@pointer) unless @pointer.null?
    end

    def now
      UV.now(@pointer) unless @pointer.null?
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

    attr_reader :pointer
  end
end