module UV
  class Pipe
    include Stream, Handle, Resource, Listener, Net

    def initialize(loop, ipc = false)
      super(loop)
      @ipc = ipc
    end

    def open(io)
      check_result! UV.pipe_open(handle, io.fileno)
    end

    def bind(name)
      check_result! UV.pipe_bind(handle, String(name))
    end

    def connect(name, &block)
      raise "no block given" unless block_given?
      @connect_block = block
      UV.pipe_connect(UV.malloc(UV.req_size(:uv_connect)), handle, String(name), callback(:on_connect))
    end

    def pending_instances=(count)
      UV.pipe_pending_instances(handle, Integer(count))
    end

    private
    def on_connect(req, status)
      UV.free(req)
      @connect_block.call(check_result(status))
    end

    def create_handle
      ptr = UV.malloc(UV.handle_size(:uv_pipe))
      check_result! UV.tty_init(loop.pointer, ptr, @ipc ? 1 : 0)
      @ipc = nil
      ptr
    end
  end
end