module UV
  class Pipe
    include Stream, Handle, Resource, Listener

    def open(io)
      check_result! UV.pipe_open(handle, Integer(io.fileno))
    end

    def bind(name)
      check_result! UV.pipe_bind(handle, String(name))
    end

    def connect(name, &block)
      raise ArgumentError, "no block given", caller unless block_given?
      @connect_block = block
      UV.pipe_connect(UV.create_request(:uv_connect), handle, String(name), callback(:on_connect))
    end

    def pending_instances=(count)
      UV.pipe_pending_instances(handle, Integer(count))
    end

    private
    def on_connect(req, status)
      UV.free(req)
      @connect_block.call(check_result(status))
    end
  end
end