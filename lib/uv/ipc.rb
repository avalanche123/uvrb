module UV
  class IPC
    include Stream

    def bind(name)
      assert_type(String, name, "name must be a String")

      check_result! UV.pipe_bind(handle, name)
    end

    def connect(name, &block)
      assert_block(block)
      assert_arity(1, block)
      assert_type(String, name, "name must be a String")

      @connect_block = block

      UV.pipe_connect(UV.create_request(:uv_connect), handle, name, callback(:on_connect))
    end

    def pending_instances=(count)
      assert_type(Integer, count, "count must be an Integer")

      UV.pipe_pending_instances(handle, count)
    end

    private
    def on_connect(req, status)
      UV.free(req)
      @connect_block.call(check_result(status))
    end
  end
end
